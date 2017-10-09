#!/bin/bash

# Let's create new simulator.
if [ "$1" == "name=iPad Air 2,OS=10.2" ]
then
  SIM_UUID=`xcrun simctl create assets-vc-ipad-ios10 com.apple.CoreSimulator.SimDeviceType.iPad-Air-2 com.apple.CoreSimulator.SimRuntime.iOS-10-2`
elif [ "$1" == "name=iPhone 6,OS=10.2" ]
then
  SIM_UUID=`xcrun simctl create assets-vc-iphone-ios10 com.apple.CoreSimulator.SimDeviceType.iPhone-6 com.apple.CoreSimulator.SimRuntime.iOS-10-2`
elif [ "$1" == "name=iPhone 6,OS=11.0" ]
then
  SIM_UUID=`xcrun simctl create assets-vc-iphone-ios11 com.apple.CoreSimulator.SimDeviceType.iPhone-6 com.apple.CoreSimulator.SimRuntime.iOS-11-0`
elif [ "$1" == "name=iPhone 6,OS=9.3" ]
then
  SIM_UUID=`xcrun simctl create assets-vc-iphone-ios9 com.apple.CoreSimulator.SimDeviceType.iPhone-6 com.apple.CoreSimulator.SimRuntime.iOS-9-3`
else
  SIM_UUID=`xcrun simctl create assets-vc-iphone-ios8 com.apple.CoreSimulator.SimDeviceType.iPhone-6 com.apple.CoreSimulator.SimRuntime.iOS-8-4`
fi

sleep 5

# To add a photo you need to load the simulator
xcrun simctl boot $SIM_UUID

sleep 5

# Let's add some assets to a newly created simulator.
xcrun simctl addmedia booted ./Media/1.JPG
sleep 2
xcrun simctl addmedia booted ./Media/2.JPG
sleep 2
xcrun simctl addmedia booted ./Media/3.JPG
sleep 2
xcrun simctl addmedia booted ./Media/4.JPG
sleep 2
xcrun simctl addmedia booted ./Media/5.JPG

# I had trouble running tests if simulator was previously booted,
# so let's make Xcode happy and shutdown the sim.
xcrun simctl shutdown $SIM_UUID

# Let's return UUID of just created sim so it can be used outside of the script.
echo $SIM_UUID

