# Spec-Gtk
The Spec Gtk bindings for Pharo

# How to install

### On Windows
You need Gtk3!  
And you need to put it at the same place of the `Pharo.exe` executable.  
To simplify the process we created a VM bundled with all the DLL and resources needed to execute GTK+3

You can get it from: http://files.pharo.org/vm/pharo-spur64-headless/win/latest-win64-GTK.zip

NOTE: If you are running under cygwin subsystem, remember to `chmod +x *`. Libraries have to be executable!

Then, you can just download a new Pharo 9.0 image: 

```
curl https://get.pharo.org/64/90 | bash
```

### On macOS: 

You need Gtk3 (installed by brew because paths are fixed for now)
```
brew install gtk+3
```

And you need the headless VM and a Pharo 9.0 image. You can get them from the zero-conf scripts: 

```
curl https://get.pharo.org/64/90+vmHeadlessLatest | bash
```


### On Linux
You need to have Gtk3 installed.

And you need the headless VM and a Pharo 9.0 image. You can get them from the zero-conf scripts: 

```
curl https://get.pharo.org/64/90+vmHeadlessLatest | bash
```


## Installing in your image

### On Windows
You need to install it from the command line since you do not have the Playground in the UI:
```
./PharoConsole.exe '.\Pharo.image' eval --save " Metacello new
        repository: 'github://pharo-spec/Spec-Gtk';
        baseline: 'SpecGtk';
        onConflict: [ :e | e useIncoming ];
        onUpgrade: [ :e | e useIncoming ];
        ignoreImage;
        load"
```

Then you will need to restart your image to let Gtk3 to take over the event loop.

### On MacOS or Linux

Open your image using `./pharo-ui Pharo.image` and evaluate:
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

If you open the image using `./pharo-ui Pharo.image`, the image should give the feeling of being significantly slower. This is because the Gtk event loop is running. You can verify this by opening the process browser: you should see a line begining with `(70) GtkRunLoop`.

## A first example

The following code should open a small UI:

```Smalltalk
app := SpApplication new 
  useBackend: #Gtk;
  yourself.

(app new: SpLabelPresenter) 
  label: 'Hello, Gtk3';
  openWithSpec
```

## Current status

Currently, only the low-level infrastructure is supported. Tools building based on solely Spec2/Gtk are under way. Be patient.
