module zlib;

import zconf;

const ZLIB_VERNUM = 0x1250;
const ZLIB_VER_MAJOR = 1;
const ZLIB_VER_MINOR = 2;
const ZLIB_VER_REVISION = 5;
const ZLIB_VER_SUBREVISION = 0;

extern (C):
alias voidpf  function(voidpf opaque, uInt items, uInt size)alloc_func;
alias void  function(voidpf opaque, voidpf address)free_func;

struct z_stream_s{
    Bytef *next_in;
    uInt avail_in;
    uLong total_in;
    Bytef *next_out;
    uInt avail_out;
    uLong total_out;
    char *msg;
    internal_state *state;
    alloc_func zalloc;
    free_func zfree;
    voidpf opaque;
    int data_type;
    uLong adler;
    uLong reserved;
}
alias z_stream_s z_stream;
alias z_stream *z_streamp;

struct gz_header_s{
    int text;
    uLong time;
    int xflags;
    int os;
    Bytef *extra;
    uInt extra_len;
    uInt extra_max;
    Bytef *name;
    uInt name_max;
    Bytef *comment;
    uInt comm_max;
    int hcrc;
    int done;
}
alias gz_header_s gz_header;
alias gz_header *gz_headerp;

const Z_NO_FLUSH = 0;
const Z_PARTIAL_FLUSH = 1;
const Z_SYNC_FLUSH = 2;
const Z_FULL_FLUSH = 3;
const Z_FINISH = 4;
const Z_BLOCK = 5;
const Z_TREES = 6;
const Z_OK = 0;
const Z_STREAM_END = 1;
const Z_NEED_DICT = 2;

const Z_NO_COMPRESSION = 0;
const Z_BEST_SPEED = 1;
const Z_BEST_COMPRESSION = 9;
const Z_FILTERED = 1;
const Z_HUFFMAN_ONLY = 2;
const Z_RLE = 3;
const Z_FIXED = 4;
const Z_DEFAULT_STRATEGY = 0;
const Z_BINARY = 0;
const Z_TEXT = 1;
alias Z_TEXT Z_ASCII;
const Z_UNKNOWN = 2;
const Z_DEFLATED = 8;
const Z_NULL = 0;

char * zlibVersion();

int  deflate(z_streamp strm, int flush);
int  deflateEnd(z_streamp strm);

int  inflate(z_streamp strm, int flush);
int  inflateEnd(z_streamp strm);

int  deflateSetDictionary(z_streamp strm, Bytef *dictionary, uInt dictLength);
int  deflateCopy(z_streamp dest, z_streamp source);
int  deflateReset(z_streamp strm);
int  deflateParams(z_streamp strm, int level, int strategy);
int  deflateTune(z_streamp strm, int good_length, int max_lazy, int nice_length, int max_chain);
uLong  deflateBound(z_streamp strm, uLong sourceLen);
int  deflatePrime(z_streamp strm, int bits, int value);
int  deflateSetHeader(z_streamp strm, gz_headerp head);
int  inflateSetDictionary(z_streamp strm, Bytef *dictionary, uInt dictLength);
int  inflateSync(z_streamp strm);
int  inflateCopy(z_streamp dest, z_streamp source);
int  inflateReset(z_streamp strm);
int  inflateReset2(z_streamp strm, int windowBits);
int  inflatePrime(z_streamp strm, int bits, int value);
int  inflateMark(z_streamp strm);
int  inflateGetHeader(z_streamp strm, gz_headerp head);
alias uint  function(void *, ubyte **)in_func;
alias int  function(void *, ubyte *, uint )out_func;
int  inflateBack(z_streamp strm, in_func in, void *in_desc, out_func out, void *out_desc);
int  inflateBackEnd(z_streamp strm);
uLong  zlibCompileFlags();
int  compress(Bytef *dest, uLongf *destLen, Bytef *source, uLong sourceLen);
int  compress2(Bytef *dest, uLongf *destLen, Bytef *source, uLong sourceLen, int level);
uLong  compressBound(uLong sourceLen);
int  uncompress(Bytef *dest, uLongf *destLen, Bytef *source, uLong sourceLen);

alias voidp gzFile;
gzFile  gzdopen(int fd, char *mode);
int  gzbuffer(gzFile file, uint size);
int  gzsetparams(gzFile file, int level, int strategy);
int  gzread(gzFile file, voidp buf, uint len);
int  gzwrite(gzFile file, voidpc buf, uint len);
int  gzprintf(gzFile file, char *format,...);
int  gzputs(gzFile file, char *s);
char * gzgets(gzFile file, char *buf, int len);
int  gzputc(gzFile file, int c);
int  gzgetc(gzFile file);
int  gzungetc(int c, gzFile file);
int  gzflush(gzFile file, int flush);
int  gzrewind(gzFile file);
int  gzeof(gzFile file);
int  gzdirect(gzFile file);
int  gzclose(gzFile file);
int  gzclose_r(gzFile file);
int  gzclose_w(gzFile file);
char * gzerror(gzFile file, int *errnum);
void  gzclearerr(gzFile file);
uLong  adler32(uLong adler, Bytef *buf, uInt len);
uLong  crc32(uLong crc, Bytef *buf, uInt len);
int  deflateInit_(z_streamp strm, int level, char *version, int stream_size);
int  inflateInit_(z_streamp strm, char *version, int stream_size);
int  deflateInit2_(z_streamp strm, int level, int method, int windowBits, int memLevel, int strategy, char *version, int stream_size);
int  inflateInit2_(z_streamp strm, int windowBits, char *version, int stream_size);
int  inflateBackInit_(z_streamp strm, int windowBits, ubyte *window, char *version, int stream_size);

gzFile  gzopen(char *, char *);
int  gzseek(gzFile , int , int );
int  gztell(gzFile );
int  gzoffset(gzFile );
uLong  adler32_combine(uLong , uLong , int );
uLong  crc32_combine(uLong , uLong , int );
char * zError(int );
int  inflateSyncPoint(z_streamp );
uLongf * get_crc_table();
int  inflateUndermine(z_streamp , int );
