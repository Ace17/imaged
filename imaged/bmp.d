// Written in the D programming language.

/**
* Copyright: Copyright 2014 -
* License: $(WEB www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
* Authors: Sebastien Alaiwan
* Date: June 09, 2014
*/
module imaged.bmp;

import
    std.stdio;

import
    imaged.image;


/**
* BMP encoder for writing out Image classes to files as BMP.
*/
class BmpEncoder : Encoder
{
    /**
    * Params:
    * img = the image containing the data to write as a bmp
    * filename = filename of the output
    * Returns: true if writing succeeded, else false.
    */
    override bool write(in Image img, string filename)
    {
        auto fp = File(filename, "wb");

        fp.rawWrite(['B', 'M']);
        writeLE4(fp, 0); // filesize: not known yet
        writeLE4(fp, 0); // reserved

        uint pixelOffset = 54;
        writeLE4(fp, pixelOffset);

        writeLE4(fp, 40); // header size
        writeLE4(fp, img.width());
        writeLE4(fp, img.height());
        writeLE2(fp, 1); // planes
        writeLE2(fp, cast(ushort)(img.stride()*8));
        writeLE4(fp, 0); // compression: RGB
        writeLE4(fp, img.width() * img.height() * img.stride());
        writeLE4(fp, 2835);
        writeLE4(fp, 2835);
        writeLE4(fp, 0);
        writeLE4(fp, 0);

        immutable pitch = img.width()*img.stride();

        for(int y=img.height()-1;y >= 0;--y)
        {
            ubyte[] rawLine;
            rawLine.length = img.width() * 3;

            // padding
            rawLine.length = (rawLine.length + 3) & ~2;

            for(int x=0;x < img.width(); ++x)
            {
                immutable pixel = img.getPixel(x, y);
                rawLine[x*3+0] = cast(ubyte)pixel.b;
                rawLine[x*3+1] = cast(ubyte)pixel.g;
                rawLine[x*3+2] = cast(ubyte)pixel.r;
            }

            fp.rawWrite(rawLine);
        }

        // now we know the file size: write it.
        immutable fileSize = fp.tell();
        fp.seek(2);
        writeLE4(fp, cast(uint)fileSize);

        return true;
    }

private:

    static void writeLE2(ref File fp, ushort value)
    {
        ubyte[2] data;
        data[0] = (value >> 0) & 0xff;
        data[1] = (value >> 8) & 0xff;
        fp.rawWrite(data);
    }

    static void writeLE4(ref File fp, uint value)
    {
        ubyte[4] data;
        data[0] = (value >> 0) & 0xff;
        data[1] = (value >> 8) & 0xff;
        data[2] = (value >> 16) & 0xff;
        data[3] = (value >> 24) & 0xff;
        fp.rawWrite(data);
    }
}


