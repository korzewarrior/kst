# kst

A minimal terminal fork of suckless's st with practical enhancements.

## Features and Differences from st

- Fast & lightweight (~1MB binary)
- **Mouse scrollback** - Added support for mouse wheel scrolling that works in all applications (not in vanilla st)
- **Transparency support** - 96% opacity by default (not in vanilla st)
- **10,000 line scrollback buffer** - Much larger than st's default (not in vanilla st)
- **Clean, minimal interface**
- **No keyboard selection mode** - Simplified interface relies on standard mouse selection instead of the keyboard selection feature from st
- **Renamed binary** - Uses 'kst' instead of 'st' to distinguish it from the original

## Install

```bash
git clone https://github.com/korzewarrior/kst.git
cd kst
make clean && make
sudo make install
```

## License

MIT 