# Spec-Gtk
The Spec Gtk bindings for Pharo

# How to install

### On Windows
You need Gtk3!  
And you need to put it at the same place of the `Pharo.exe` executable.  
To simplify the process we created a VM bundled with all the DLL and resources needed to execute GTK+3  

You can get it from: http://files.pharo.org/vm/pharo-spur64-headless/win/latest-win64-GTK.zip

NOTE: If you are running under cygwin subsystem, remember to `chmod +x *`. Libraries have to be executable!

### On macOS: 

You need Gtk3 (installed by brew because paths are fixed for now)
```
brew install gtk+3
```

### On Linux
You need to have Gtk3 installed (this should be already the case).


## Installing in your image

1) Download a Pharo 11.0 image:

```
curl get.pharo.org/110 | bash
```

2) Open your image using `./pharo-ui Pharo.image` and evaluate:
```Smalltalk
 Metacello new
        repository: 'github://pharo-spec/Spec-Gtk';
        baseline: 'SpecGtk';
        onConflict: [ :e | e useIncoming ];
        onUpgrade: [ :e | e useIncoming ];
        ignoreImage;
        load
```
After the execution, save the image, and quit.

In macOS, if you open the image using `./pharo-ui Pharo.image`, the image should give the feeling of being significantly slower. This is because the Gtk event loop is running. You can verify this by opening the process browser: you should see a line begining with `(70) GtkRunLoop`.

## A first example

The following code should open a small UI:

```Smalltalk
SpLabelPresenter new
	application: (SpApplication new useBackend: #Gtk);	
	label: 'Hello, Gtk3';
	open.
```

## Current status

Currently, only the low-level infrastructure is supported. Tools building based on solely Spec2/Gtk are under way. Be patient.
