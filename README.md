# TTLSet Utility #
This little utility allows to set the needed TTL values both for TCP IP 4 and IP V6. It currently cupports Windows only.
[What is TTL?](https://en.wikipedia.org/wiki/Time_to_live)
## UAC warning ##
When you've start the TTLSet utility, Windows will show you UAC request window. It's right, because we're working with Windows registry. Windows doesn't allows to change something in this registry branch, so TTL Set utility should get the extended rights.
## Specifying the values ##
TTLSet Utility supports both writing a needed value and remove this from appropriated Windows registry key.
+ If the checkbox near TTL value spin box is not checked it means that either TTL value is not set in your Windows copy or will be deleted when you've press the Set TTL button. The spin box is gray at this case.
+ If the checkbox near a value spin box is checked, the spin box will be set active and you would set needed TTL value.
+ If the Ping button is presset, the utility will ping localhost and retrieves the TTL value from ping result if it is possible. If the TTL value successfully retrieved, the checkbox will be checked to needed spin box will able to accept new value.
When you'll set needed TTL values bot for TCP IP V4 and TCP IP V6, press the "Set TTL" button and changes will be applied.
## Ping process warning ##
TTLSet utility pings the address 127.0.0.1 for IP V4 and ::1 for IP V6. Unfortunately, IP V6 currently doesn't contains the TTL value for pong, but it also realized. If you know how to retrieve the TTL value for IP V6, feel free to pulrequest the proper method.
## Presets ##
The utility has a few amount of presets to quick set the pre-defined TTL values. Just choose needed preset and press the "Set TTL" button.
## Windows support ##
TTL Set Utility currently supports Windows only. If you're user of another operating system and known with PureBasic, feel free to pullrequest the realisation for your OS!
## Building the source code ##
TTL Set utility is written in PureBasic language. It has developed on PB 5.72. If you don't have this version, you should acquire this. If you have PureBasic version earlier, you have to redirect some constants in the source code.