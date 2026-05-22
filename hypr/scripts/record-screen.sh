#!/bin/bash
# record-screen.sh - Screen recording script
# Place in ~/.config/hypr/scripts/

# Required dependencies: wf-recorder, slurp, libnotify

# Create directory if it doesn't exist
RECORDINGS_DIR="$HOME/Videos/Recordings"
mkdir -p "$RECORDINGS_DIR"

# Generate filename with date and time
FILENAME="$RECORDINGS_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"

# Check if already recording
if pgrep -x "wf-recorder" > /dev/null; then
    # Stop recording
    pkill -SIGINT wf-recorder

    # Notify user
    notify-send -a "Screen Recorder" -u normal "Recording stopped" "Saved to $FILENAME"

    # Play sound
    paplay /usr/share/sounds/freedesktop/stereo/screen-capture.oga &
else
    # Ask user to select area
    notify-send -a "Screen Recorder" -u normal "Select area to record" "Draw a rectangle to start recording"
    GEOMETRY=$(slurp)

    if [ -n "$GEOMETRY" ]; then
        # Start recording with audio
        notify-send -a "Screen Recorder" -u critical "Recording started" "Recording to $FILENAME"

        # Play sound
        paplay /usr/share/sounds/freedesktop/stereo/screen-capture.oga &

        # Record with hardware acceleration if available
        if lspci | grep -i nvidia > /dev/null; then
            # NVIDIA
            wf-recorder -g "$GEOMETRY" -f "$FILENAME" --codec=h264_nvenc
        else
            # Try to use VA-API if available
            wf-recorder -g "$GEOMETRY" -f "$FILENAME" --codec=h264_vaapi || \
                wf-recorder -g "$GEOMETRY" -f "$FILENAME"
        fi
    else
        notify-send -a "Screen Recorder" -u normal "Recording cancelled"
    fi
fi
