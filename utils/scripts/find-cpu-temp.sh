#!/usr/bin/env bash
# Find CPU temperature with a 5-level fallback chain.
# Outputs millidegrees Celsius (e.g. 49000 = 49.0°C).
# Exit 1 if no source found.

# Try 1: thermal_zone with CPU/Package/x86_pkg type
for z in /sys/class/thermal/thermal_zone*/; do
    type=$(cat "$z/type" 2>/dev/null)
    case "$type" in
        *x86_pkg*|*CPU*|*Package*|*coretemp*|*cpu*)
            temp=$(cat "$z/temp" 2>/dev/null)
            if [ -n "$temp" ] && [ "$temp" -gt 0 ] 2>/dev/null; then
                echo "$temp"; exit 0
            fi
            ;;
    esac
done

# Try 2: fallback to first thermal_zone with valid temp
for z in /sys/class/thermal/thermal_zone*/; do
    temp=$(cat "$z/temp" 2>/dev/null)
    if [ -n "$temp" ] && [ "$temp" -gt 0 ] 2>/dev/null; then
        echo "$temp"; exit 0
    fi
done

# Try 3: hwmon interface — match known CPU labels
for f in /sys/class/hwmon/hwmon*/temp*_input; do
    [ -e "$f" ] || continue
    label=$(cat "${f%_input}_label" 2>/dev/null || true)
    case "$label" in
        *Core*|*Tdie*|*Tctl*|*CPU*|*cpu*|*edge*|*Package*)
            temp=$(cat "$f" 2>/dev/null)
            if [ -n "$temp" ] && [ "$temp" -gt 0 ] 2>/dev/null; then
                echo "$temp"; exit 0
            fi
            ;;
    esac
done

# Try 4: fallback to first hwmon temp input with valid reading
for f in /sys/class/hwmon/hwmon*/temp*_input; do
    [ -e "$f" ] || continue
    temp=$(cat "$f" 2>/dev/null)
    if [ -n "$temp" ] && [ "$temp" -gt 0 ] 2>/dev/null; then
        echo "$temp"; exit 0
    fi
done

# Try 5: sensors command (requires lm-sensors)
if command -v sensors &>/dev/null; then
    result=$(sensors -j 2>/dev/null | python3 -c "
import sys, json
data = json.load(sys.stdin)
for chip, readings in data.items():
    for key, val in readings.items():
        if 'input' in key and 'temp' in key.lower():
            v = val.get('input')
            if v is not None and v > 0:
                print(int(v * 1000))
                sys.exit(0)
" 2>/dev/null)
    if [ -n "$result" ]; then
        echo "$result"; exit 0
    fi
fi

exit 1
