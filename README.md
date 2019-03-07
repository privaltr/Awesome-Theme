Personal AwesomeWM config and Rice
==================================

![Preview gif](rice.gif?raw=true)

Table of contents
=================
<!--ts-->
   * [Intro](#personal-awesomewm-config-and-rice)
   * [Table of contents](#table-of-contents)
   * [Programs](#programs)
      * [Required](#required)
      * [Trays](#trays)
      * [Personal favorites](#personal-favorites)
   * [AUR Helper](#aur-helper)
   * [Lockscreen](#lockscreen)
   * [Dolphin icons missing](#dolphin-icons-missing)
<!--te-->

Programs
========

Required
--------

Trays
-----

Personal favorites
------------------

AUR Helper
==========
[**Y**et **A**nother **Y**ogurt](https://github.com/Jguer/yay) - An AUR Helper Written in Go
```
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```
> yay does its job, but [aurutils](https://github.com/AladW/aurutils) gives you absolute control over everything and more flexibility.


Lockscreen
==========
[i3lock-fancy](https://github.com/meskarune/i3lock-fancy) is an i3lock bash script that takes a screenshot of the desktop, blurs the background and adds a lock icon and text.
```
sudo yay -Sy i3lock-color-git i3lock-fancy-dualmonitors-git
```


Dolphin icons missing
=====================
Unlike Qt4, Qt5 does not ship a qtconfig utility to configure fonts, icons or styles. Instead, it will try to use the settings from the running desktop environment. In KDE Plasma or GNOME this works well, but in other less popular desktop environments or window managers it can lead to missing icons in Qt5 applications.
```
sudo pacman -Sy qt5-styleplugins  
echo 'QT_QPA_PLATFORMTHEME=gtk2' | sudo tee --append /etc/enviroment
```
> Another solution is provided by the qt5ct package, which provides a Qt5 QPA independent of the desktop environment and a configuration utility. After installing the package, run qt5ct to set an icon theme, and set the environment variable Q\_QPA\_PLATFORMTHEME="qt5ct" so that the settings are picked up by Qt applications. Alternatively, use --platformtheme qt5ct as argument to the Qt5 application. 
