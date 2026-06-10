# Spec-Gtk
The Spec Gtk bindings for Pharo

# How to install

### On macOS: 
You need Gtk4 (installed by brew because paths are fixed for now)
```
brew install gtk+4
```

### On Linux

**WARNING:** You cannot run gtk applications using a PharoVM downloaded with zeroconf. 
The reason is zeroconf downloads some libraries required to run the vm and those libraries 
conflicts with the system libraries.  
Instead, please go to the [OBS (Open Build Service) Pharo Package](https://software.opensuse.org//download.html?project=devel:languages:pharo:stable&package=pharo-ui) built and install the VM for your distribution. 

You need to have Gtk4 installed (this should be already the case).
You can verify with this command: 
```
apt list --installed | grep gtk4 
```
or
```
dnf list --installed | grep gtk4 
```
You will need to remove some library files shipped with the Pharo VM:
```
rm ~/pharo/vm/lib/libfreetype.so* ~/pharo/vm/lib/libcairo*.so*
```

### On Windows
Windows version is currently not working (an FFI problem we are working to solve, 
hopefully in the next weeks.  
Sorry for the (momentary) inconvenience.
<!--
You need Gtk4!  
And you need to put it at the same place of the `Pharo.exe` executable.  
To simplify the process we created a VM bundled with all the DLL and resources needed to execute GTK+3  

You can get it from: http://files.pharo.org/vm/pharo-spur64-headless/win/latest-win64-GTK.zip

NOTE: If you are running under cygwin subsystem, remember to `chmod +x *`. Libraries have to be executable!
--> 

## Installing in your image

1) Download a Pharo 14.0 image:

```
curl get.pharo.org/140 | bash
```

2) Open your image using `./pharo --worker Pharo.image --interactive` and evaluate:
```Smalltalk
 Metacello new
        repository: 'github://pharo-spec/Spec-Gtk:main';
        baseline: 'SpecGtk';
        onConflict: [ :e | e useIncoming ];
        onUpgrade: [ :e | e useIncoming ];
        ignoreImage;
        load
```
After the execution, save the image, and quit.

Running GTK now requires the Pharo VM to be run in worker mode: `./pharo --worker Pharo.image`.

In macOS, running the World in Morphic is not yet possible since the SDL loop will execute in the worker and assume Cocoa is in the same thread. It cannot work since Cocoa must run in the main thread.

## A first example

The following code should open a small UI:

```Smalltalk
SpLabelPresenter new
	application: (SpApplication new useBackend: #Gtk);	
	label: 'Hello, Gtk4';
	open.
```

## Current status

Currently, only the low-level infrastructure is supported. Tools building based on solely Spec2/Gtk are under way. Be patient.
