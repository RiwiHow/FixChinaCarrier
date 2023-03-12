# FixChinaCarrier
English

[简体中文](https://github.com/RiwiHow/FixChinaCarrier/blob/master/Doc/Chinese%20Simplified.md)

## Features

- Addresses slow internet speeds on Chinese carriers
- Systemless method for replacement
- Supports multiple flexible modifications

## How it works?

The module replaces the system's original `apns-conf.xml` with MIUI's version using Magisk's [Magic Mount](https://topjohnwu.github.io/Magisk/details.html#magic-mount).

## Requestments

- Android 8 or higher and use `apns-conf.xml` as the device's APN configuration file
- Magisk 20.4 or higher with the manager installed

## How to use it?
Download the module from [releases](https://github.com/RiwiHow/FixChinaCarrier/releases) and install it through Magisk Manager.

After installation, go to the `Access Point Names (APN)` settings and manually `Reset to default`.

Here's an example:

<details>
<summary>Before using</summary>
<img src="Doc/images/3.png">
</details>

<details>
<summary>After using</summary>
<img src="Doc/images/1.png">
</details>

## Troubleshooting

#### Install failed with "Upzip error"

Please download the module again and ensure that the download process is complete.

#### I install it but there is only a blank directory in `/data/adb/modules/fixchinacarrier`

This may occur if you upgraded to a newer version from an older version. Reinstalling the module through Magisk Manager should resolve the issue.

#### Installation failed! It says "The ROM is not supported."

As the message indicates, the ROM you are using is currently not supported. You can open an issue with a detailed description and installation log or submit a pull request to help resolve the issue.

## Credits

* [Magisk](https://github.com/topjohnwu/Magisk) for providing the tools

* [Qingxu](https://github.com/RimuruW) for code work

* [vvb2060](https://github.com/vvb2060) and [落叶凄凉TEL](http://www.coolapk.com/u/2277637) for provide guidances

* [Zackptg5](https://forum.xda-developers.com/m/zackptg5.6037748/) for providing the Magisk module template

