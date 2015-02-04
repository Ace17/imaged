import imaged.image;
import std.stream;

int main()
{
    auto img = generateTestPattern();
    img.write("generated.bmp");
    img.write("generated.png");
    return 0;
}

Image generateTestPattern()
{
    immutable width = 71;
    immutable height = 31;
    immutable pixelFormat = Px.R8G8B8;

    auto img = new Img!(pixelFormat)(width, height);

    for(int y=0; y<height; ++y)
    {
        for(int x=0; x<width; ++x)
        {
            immutable offset = (width * y + x) * img.stride();
            immutable patternIndex = ((x/4) + (y/4));
            auto data = img.pixels();
            data[offset + 0] = patternIndex % 3 == 0 ? 0xFF : 00;
            data[offset + 1] = patternIndex % 3 == 1 ? 0xFF : 00;
            data[offset + 2] = 0x00;
            if(img.stride() > 3)
              data[offset + 3] = 0xff;
        }
    }

    return img;
}

unittest
{

  Image parseBuffer(const ubyte[] buffer)
  {
    auto dec = getDecoder("*.bmp");
    auto s = new MemoryStream(cast(ubyte[])buffer);
    dec.parseStream(s);
    return dec.image();
  }

  {
    immutable pic = cast(immutable ubyte[])import("test/bmp/test1.bmp");
    auto img = parseBuffer(pic);
    assert(img.width == 71);
    assert(img.height == 31);
  }

  {
    immutable pic = cast(immutable ubyte[])import("test/bmp/test2.bmp");
    auto img = parseBuffer(pic);
    assert(img.width == 25);
    assert(img.height == 17);
  }
}

