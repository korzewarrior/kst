# kst - Simple Terminal

A minimalist terminal forked from [suckless st](https://st.suckless.org/) with practical enhancements.

## Features

- **Lightweight**: ~1MB binary size with minimal dependencies
- **Fast**: Optimized performance with low latency
- **Scrollback buffer**: 10,000 line scrollback with mouse wheel support
- **Modern fonts**: TrueType/OpenType/Color Emoji support
- **Transparency**: Alpha channel transparency for terminal background
- **Clean UI**: No clutter, just a simple terminal interface
- **Box drawing**: Improved rendering of Unicode box drawing characters

## Requirements

- Xlib header files
- Fontconfig/Freetype2 development files
- libX11 and libXft

## Installation

### From source

```bash
git clone https://github.com/korzewarrior/kst.git
cd kst
make
sudo make install
```

## Configuration

kst is configured by editing `config.def.h` and recompiling (the suckless way). 

### Changing colors

The default color scheme uses classic terminal colors, but you can easily change this by editing the `colorname` array in `config.def.h`.

### Transparency

Adjust the `alpha` value (0.0 = fully transparent, 1.0 = fully opaque) in `config.def.h`.

### Fonts

Change the font by modifying the `font` variable in `config.def.h`. Additional fonts can be specified in the `font2` array for emoji and icons.

## Shortcuts

- Scroll: `Shift+PageUp`, `Shift+PageDown` or mousewheel
- Zoom: `Ctrl+Shift+Home` (reset), `Ctrl+Shift+PageUp` (in), `Ctrl+Shift+PageDown` (out)
- Copy/Paste: `Ctrl+Shift+C`, `Ctrl+Shift+V` or middle click

## License

MIT 