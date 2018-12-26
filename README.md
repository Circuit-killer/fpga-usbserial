# usb-serial core

Enumerates as USB1.1 serial port seen as /dev/ttyACM0 on linux.
Buffers typed characters. After pressin RETURN prints buffered
characters in reverse order.

# hardware

Total 6 FPGA pins are used with "27-ohm" interface.
(see ["usb" sheet of ULX3S schematics](https://github.com/emard/ulx3s/tree/master/doc/schematics.pdf)):

    2 differential input pins
    2 single-ended bidirectional pins
    2 single-ended pullup/pulldown control pins (optional)

To save 2 pins, instead of pullup/pulldown control pins,
a fixed pullup resistor of 1.5k between D+ and 3.3V can be used.

USB standard requires tolerance to +5V on any pin,
therefore 27-ohm resistors and 3.6V Zener diodes protect FPGA from +5V.
Core can work without 3.6V Zener diodes if normal
USB devices with properly wired connectors are used.

# issues

It doesn't enumerate (doesn't work at all) on some USB2.x ports.
It doesn't work reliable (looses chars) on most USB3.x ports.
