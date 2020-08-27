# Fiber Optic Driver

An easy-to-use system to illuminate plastic fiber optic bundles with individually-addressible RGB LEDs.

![Exploded mockup](mockup.png)

This project addresses a weird need that I've had for a few projects: needing to light up plastic fibers with programmable LEDs.
This 3D printable housing registers crimped bundles of plastic fibers with standard LED strips.

To use it, first crimp small bundles of 1mm plastic fibers with unshrouded wire ferrules and a [hex crimper][hex-crimper].
I've found that with 1mm fibers, I was able to get the following bundle sizes:

* 10AWG — 6-7 fibers ([Digikey 288-1111-ND][10awg])
* 12AWG — 4-5 fibers ([Digikey 288-1107-ND][12awg])
* 14AWG — 2-3 fibers ([Digikey 288-1102-ND][14awg])
* 18AWG — 1 fiber ([Digikey 288-1090-ND][18awg])

Make sure to get ferrules of the appropriate length. I standardized on 12mm (except for the 18AWG).

For the LED strip, I'm using a 60/m strip of SK9822 LEDs. For fibers, it's important to use SK9822 or APA102
as the tiny point light sources of the fiber ends really show slow PWM like the 450Hz of the WS2811s. I wouldn't
recommend anything below 2kHz PWM frequency.

[10awg]: https://www.digikey.com/product-detail/en/american-electrical-inc/121210600/288-1111-ND/266477
[12awg]: https://www.digikey.com/product-detail/en/american-electrical-inc/121210400/288-1107-ND/266473
[14awg]: https://www.digikey.com/product-detail/en/american-electrical-inc/121210250/288-1102-ND/266468
[18awg]: https://www.digikey.com/product-detail/en/american-electrical-inc/12810100/288-1090-ND/266456
[hex-crimper]: https://www.amazon.com/gp/product/B07XBLGPCY/
