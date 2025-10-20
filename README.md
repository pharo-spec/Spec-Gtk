# Spec-Gtk
The Spec Gtk bindings for Pharo

# How to install

### On Windows
You need Gtk4!  
And you need to put it at the same place of the `Pharo.exe` executable.  
To simplify the process we created a VM bundled with all the DLL and resources needed to execute GTK+3  

You can get it from: http://files.pharo.org/vm/pharo-spur64-headless/win/latest-win64-GTK.zip

NOTE: If you are running under cygwin subsystem, remember to `chmod +x *`. Libraries have to be executable!

### On macOS: 

You need Gtk4 (installed by brew because paths are fixed for now)
```
brew install gtk+4
```

### On Linux
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

## Installing in your image

1) Download a Pharo 12.0 image:

```
curl get.pharo.org/120 | bash
```

2) Open your image using `./pharo-ui Pharo.image` and evaluate:
```Smalltalk
 Metacello new
        repository: 'github://pharo-spec/Spec-Gtk:gtk4';
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