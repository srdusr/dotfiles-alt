#!/bin/bash

killall -q xob
pkill -9 manage-volume
pkill -9 manage-brightness
pkill -9 manage-microphone

"$HOME"/.config/xob/manage-volume | xob -s default &
"$HOME"/.config/xob/manage-brightness | xob -s default &
"$HOME"/.config/xob/manage-microphone | xob -s default &
