# usb-serial core

Enumerates as USB1.1 serial port seen as /dev/ttyACM0 on linux.
Buffers typed characters. After pressin RETURN prints buffered
characters in reverse order.

Total 6 FPGA pins are used
(see ["usb" sheet of ULX3S schematics](https://github.com/emard/ulx3s/tree/master/doc/schematics.pdf)):

    2 differential input pins
    2 single-ended bidirectional pins
    2 single-ended pullup/pulldown control pins (optional)

To save 2 pins, instead of pullup/pulldown control pins,
a fixed pullup resistor of 1.5k between D+ and 3.3V can be used.
