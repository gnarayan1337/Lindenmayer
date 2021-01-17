#!/bin/sh

#  xcode.sh
#  Lindenmayer
#
#  Created by Mukul Agarwal on 1/16/21.
#  

if [ "$(uname)" = "Darwin" ]; then
		open -axcode .
else
		echo "Not macOS. Xcode is unavailable."
fi

