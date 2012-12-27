module opengl.gl_1_0;

import std.c.stdio, std.c.stdarg;

const GL_VERSION_1_1 = 1;

extern (C):
alias uint    GLenum;
alias ubyte   GLboolean;
alias uint    GLbitfield;
alias void    GLvoid;
alias byte    GLbyte;
alias short   GLshort;
alias int     GLint;
alias char    GLchar;
alias ubyte   GLubyte;
alias ushort  GLushort;
alias uint    GLuint;
alias int     GLsizei;
alias float   GLfloat;
alias float   GLclampf;
alias double  GLdouble;
alias double  GLclampd;
alias ptrdiff_t GLintptr;
alias ptrdiff_t GLsizeiptr;

/* Constants */
const GL_FALSE = 0x0;
const GL_TRUE = 0x1;

/* Data types */
const GL_BYTE = 0x1400;
const GL_UNSIGNED_BYTE = 0x1401;
const GL_SHORT = 0x1402;
const GL_UNSIGNED_SHORT = 0x1403;
const GL_INT = 0x1404;
const GL_UNSIGNED_INT = 0x1405;
const GL_FLOAT = 0x1406;
const GL_DOUBLE = 0x140A;
const GL_2_BYTES = 0x1407;
const GL_3_BYTES = 0x1408;
const GL_4_BYTES = 0x1409;

/* Primitives */
const GL_POINTS = 0x0000;
const GL_LINES = 0x0001;
const GL_LINE_LOOP = 0x0002;
const GL_LINE_STRIP = 0x0003;
const GL_TRIANGLES = 0x0004;
const GL_TRIANGLE_STRIP = 0x0005;
const GL_TRIANGLE_FAN = 0x0006;
const GL_QUADS = 0x0007;
const GL_QUAD_STRIP = 0x0008;
const GL_POLYGON = 0x0009;

/* Vertex Arrays */
const GL_VERTEX_ARRAY = 0x8074;
const GL_NORMAL_ARRAY = 0x8075;
const GL_COLOR_ARRAY = 0x8076;
const GL_INDEX_ARRAY = 0x8077;
const GL_TEXTURE_COORD_ARRAY = 0x8078;
const GL_EDGE_FLAG_ARRAY = 0x8079;
const GL_VERTEX_ARRAY_SIZE = 0x807A;
const GL_VERTEX_ARRAY_TYPE = 0x807B;
const GL_VERTEX_ARRAY_STRIDE = 0x807C;
const GL_NORMAL_ARRAY_TYPE = 0x807E;
const GL_NORMAL_ARRAY_STRIDE = 0x807F;
const GL_COLOR_ARRAY_SIZE = 0x8081;
const GL_COLOR_ARRAY_TYPE = 0x8082;
const GL_COLOR_ARRAY_STRIDE = 0x8083;
const GL_INDEX_ARRAY_TYPE = 0x8085;
const GL_INDEX_ARRAY_STRIDE = 0x8086;
const GL_TEXTURE_COORD_ARRAY_SIZE = 0x8088;
const GL_TEXTURE_COORD_ARRAY_TYPE = 0x8089;
const GL_TEXTURE_COORD_ARRAY_STRIDE = 0x808A;
const GL_EDGE_FLAG_ARRAY_STRIDE = 0x808C;
const GL_VERTEX_ARRAY_POINTER = 0x808E;
const GL_NORMAL_ARRAY_POINTER = 0x808F;
const GL_COLOR_ARRAY_POINTER = 0x8090;
const GL_INDEX_ARRAY_POINTER = 0x8091;
const GL_TEXTURE_COORD_ARRAY_POINTER = 0x8092;
const GL_EDGE_FLAG_ARRAY_POINTER = 0x8093;
const GL_V2F = 0x2A20;
const GL_V3F = 0x2A21;
const GL_C4UB_V2F = 0x2A22;
const GL_C4UB_V3F = 0x2A23;
const GL_C3F_V3F = 0x2A24;
const GL_N3F_V3F = 0x2A25;
const GL_C4F_N3F_V3F = 0x2A26;
const GL_T2F_V3F = 0x2A27;
const GL_T4F_V4F = 0x2A28;
const GL_T2F_C4UB_V3F = 0x2A29;
const GL_T2F_C3F_V3F = 0x2A2A;
const GL_T2F_N3F_V3F = 0x2A2B;
const GL_T2F_C4F_N3F_V3F = 0x2A2C;
const GL_T4F_C4F_N3F_V4F = 0x2A2D;

/* Matrix Mode */
const GL_MATRIX_MODE = 0x0BA0;
const GL_MODELVIEW = 0x1700;
const GL_PROJECTION = 0x1701;
const GL_TEXTURE = 0x1702;

/* Points */
const GL_POINT_SMOOTH = 0x0B10;
const GL_POINT_SIZE = 0x0B11;
const GL_POINT_SIZE_GRANULARITY = 0x0B13;
const GL_POINT_SIZE_RANGE = 0x0B12;

/* Lines */
const GL_LINE_SMOOTH = 0x0B20;
const GL_LINE_STIPPLE = 0x0B24;
const GL_LINE_STIPPLE_PATTERN = 0x0B25;
const GL_LINE_STIPPLE_REPEAT = 0x0B26;
const GL_LINE_WIDTH = 0x0B21;
const GL_LINE_WIDTH_GRANULARITY = 0x0B23;
const GL_LINE_WIDTH_RANGE = 0x0B22;

/* Polygons */
const GL_POINT = 0x1B00;
const GL_LINE = 0x1B01;
const GL_FILL = 0x1B02;
const GL_CW = 0x0900;
const GL_CCW = 0x0901;
const GL_FRONT = 0x0404;
const GL_BACK = 0x0405;
const GL_POLYGON_MODE = 0x0B40;
const GL_POLYGON_SMOOTH = 0x0B41;
const GL_POLYGON_STIPPLE = 0x0B42;
const GL_EDGE_FLAG = 0x0B43;
const GL_CULL_FACE = 0x0B44;
const GL_CULL_FACE_MODE = 0x0B45;
const GL_FRONT_FACE = 0x0B46;
const GL_POLYGON_OFFSET_FACTOR = 0x8038;
const GL_POLYGON_OFFSET_UNITS = 0x2A00;
const GL_POLYGON_OFFSET_POINT = 0x2A01;
const GL_POLYGON_OFFSET_LINE = 0x2A02;
const GL_POLYGON_OFFSET_FILL = 0x8037;

/* Display Lists */
const GL_COMPILE = 0x1300;
const GL_COMPILE_AND_EXECUTE = 0x1301;
const GL_LIST_BASE = 0x0B32;
const GL_LIST_INDEX = 0x0B33;
const GL_LIST_MODE = 0x0B30;

/* Depth buffer */
const GL_NEVER = 0x0200;
const GL_LESS = 0x0201;
const GL_EQUAL = 0x0202;
const GL_LEQUAL = 0x0203;
const GL_GREATER = 0x0204;
const GL_NOTEQUAL = 0x0205;
const GL_GEQUAL = 0x0206;
const GL_ALWAYS = 0x0207;
const GL_DEPTH_TEST = 0x0B71;
const GL_DEPTH_BITS = 0x0D56;
const GL_DEPTH_CLEAR_VALUE = 0x0B73;
const GL_DEPTH_FUNC = 0x0B74;
const GL_DEPTH_RANGE = 0x0B70;
const GL_DEPTH_WRITEMASK = 0x0B72;
const GL_DEPTH_COMPONENT = 0x1902;

/* Lighting */
const GL_LIGHTING = 0x0B50;
const GL_LIGHT0 = 0x4000;
const GL_LIGHT1 = 0x4001;
const GL_LIGHT2 = 0x4002;
const GL_LIGHT3 = 0x4003;
const GL_LIGHT4 = 0x4004;
const GL_LIGHT5 = 0x4005;
const GL_LIGHT6 = 0x4006;
const GL_LIGHT7 = 0x4007;
const GL_SPOT_EXPONENT = 0x1205;
const GL_SPOT_CUTOFF = 0x1206;
const GL_CONSTANT_ATTENUATION = 0x1207;
const GL_LINEAR_ATTENUATION = 0x1208;
const GL_QUADRATIC_ATTENUATION = 0x1209;
const GL_AMBIENT = 0x1200;
const GL_DIFFUSE = 0x1201;
const GL_SPECULAR = 0x1202;
const GL_SHININESS = 0x1601;
const GL_EMISSION = 0x1600;
const GL_POSITION = 0x1203;
const GL_SPOT_DIRECTION = 0x1204;
const GL_AMBIENT_AND_DIFFUSE = 0x1602;
const GL_COLOR_INDEXES = 0x1603;
const GL_LIGHT_MODEL_TWO_SIDE = 0x0B52;
const GL_LIGHT_MODEL_LOCAL_VIEWER = 0x0B51;
const GL_LIGHT_MODEL_AMBIENT = 0x0B53;
const GL_FRONT_AND_BACK = 0x0408;
const GL_SHADE_MODEL = 0x0B54;
const GL_FLAT = 0x1D00;
const GL_SMOOTH = 0x1D01;
const GL_COLOR_MATERIAL = 0x0B57;
const GL_COLOR_MATERIAL_FACE = 0x0B55;
const GL_COLOR_MATERIAL_PARAMETER = 0x0B56;
const GL_NORMALIZE = 0x0BA1;

/* User clipping planes */
const GL_CLIP_PLANE0 = 0x3000;
const GL_CLIP_PLANE1 = 0x3001;
const GL_CLIP_PLANE2 = 0x3002;
const GL_CLIP_PLANE3 = 0x3003;
const GL_CLIP_PLANE4 = 0x3004;
const GL_CLIP_PLANE5 = 0x3005;

/* Accumulation buffer */
const GL_ACCUM_RED_BITS = 0x0D58;
const GL_ACCUM_GREEN_BITS = 0x0D59;
const GL_ACCUM_BLUE_BITS = 0x0D5A;
const GL_ACCUM_ALPHA_BITS = 0x0D5B;
const GL_ACCUM_CLEAR_VALUE = 0x0B80;
const GL_ACCUM = 0x0100;
const GL_ADD = 0x0104;
const GL_LOAD = 0x0101;
const GL_MULT = 0x0103;
const GL_RETURN = 0x0102;

/* Alpha testing */
const GL_ALPHA_TEST = 0x0BC0;
const GL_ALPHA_TEST_REF = 0x0BC2;
const GL_ALPHA_TEST_FUNC = 0x0BC1;

/* Blending */
const GL_BLEND = 0x0BE2;
const GL_BLEND_SRC = 0x0BE1;
const GL_BLEND_DST = 0x0BE0;
const GL_ZERO = 0x0;
const GL_ONE = 0x1;
const GL_SRC_COLOR = 0x0300;
const GL_ONE_MINUS_SRC_COLOR = 0x0301;
const GL_SRC_ALPHA = 0x0302;
const GL_ONE_MINUS_SRC_ALPHA = 0x0303;
const GL_DST_ALPHA = 0x0304;
const GL_ONE_MINUS_DST_ALPHA = 0x0305;
const GL_DST_COLOR = 0x0306;
const GL_ONE_MINUS_DST_COLOR = 0x0307;
const GL_SRC_ALPHA_SATURATE = 0x0308;
const GL_CONSTANT_COLOR = 0x8001;
const GL_ONE_MINUS_CONSTANT_COLOR = 0x8002;
const GL_CONSTANT_ALPHA = 0x8003;
const GL_ONE_MINUS_CONSTANT_ALPHA = 0x8004;

/* Render Mode */
const GL_FEEDBACK = 0x1C01;
const GL_RENDER = 0x1C00;
const GL_SELECT = 0x1C02;

/* Feedback */
const GL_2D = 0x0600;
const GL_3D = 0x0601;
const GL_3D_COLOR = 0x0602;
const GL_3D_COLOR_TEXTURE = 0x0603;
const GL_4D_COLOR_TEXTURE = 0x0604;
const GL_POINT_TOKEN = 0x0701;
const GL_LINE_TOKEN = 0x0702;
const GL_LINE_RESET_TOKEN = 0x0707;
const GL_POLYGON_TOKEN = 0x0703;
const GL_BITMAP_TOKEN = 0x0704;
const GL_DRAW_PIXEL_TOKEN = 0x0705;
const GL_COPY_PIXEL_TOKEN = 0x0706;
const GL_PASS_THROUGH_TOKEN = 0x0700;
const GL_FEEDBACK_BUFFER_POINTER = 0x0DF0;
const GL_FEEDBACK_BUFFER_SIZE = 0x0DF1;
const GL_FEEDBACK_BUFFER_TYPE = 0x0DF2;

/* Selection */
const GL_SELECTION_BUFFER_POINTER = 0x0DF3;
const GL_SELECTION_BUFFER_SIZE = 0x0DF4;

/* Fog */
const GL_FOG = 0x0B60;
const GL_FOG_MODE = 0x0B65;
const GL_FOG_DENSITY = 0x0B62;
const GL_FOG_COLOR = 0x0B66;
const GL_FOG_INDEX = 0x0B61;
const GL_FOG_START = 0x0B63;
const GL_FOG_END = 0x0B64;
const GL_LINEAR = 0x2601;
const GL_EXP = 0x0800;
const GL_EXP2 = 0x0801;

/* Logic Ops */
const GL_LOGIC_OP = 0x0BF1;
const GL_INDEX_LOGIC_OP = 0x0BF1;
const GL_COLOR_LOGIC_OP = 0x0BF2;
const GL_LOGIC_OP_MODE = 0x0BF0;
const GL_CLEAR = 0x1500;
const GL_SET = 0x150F;
const GL_COPY = 0x1503;
const GL_COPY_INVERTED = 0x150C;
const GL_NOOP = 0x1505;
const GL_INVERT = 0x150A;
const GL_AND = 0x1501;
const GL_NAND = 0x150E;
const GL_OR = 0x1507;
const GL_NOR = 0x1508;
const GL_XOR = 0x1506;
const GL_EQUIV = 0x1509;
const GL_AND_REVERSE = 0x1502;
const GL_AND_INVERTED = 0x1504;
const GL_OR_REVERSE = 0x150B;
const GL_OR_INVERTED = 0x150D;

/* Stencil */
const GL_STENCIL_TEST = 0x0B90;
const GL_STENCIL_WRITEMASK = 0x0B98;
const GL_STENCIL_BITS = 0x0D57;
const GL_STENCIL_FUNC = 0x0B92;
const GL_STENCIL_VALUE_MASK = 0x0B93;
const GL_STENCIL_REF = 0x0B97;
const GL_STENCIL_FAIL = 0x0B94;
const GL_STENCIL_PASS_DEPTH_PASS = 0x0B96;
const GL_STENCIL_PASS_DEPTH_FAIL = 0x0B95;
const GL_STENCIL_CLEAR_VALUE = 0x0B91;
const GL_STENCIL_INDEX = 0x1901;
const GL_KEEP = 0x1E00;
const GL_REPLACE = 0x1E01;
const GL_INCR = 0x1E02;
const GL_DECR = 0x1E03;

/* Buffers, Pixel Drawing/Reading */
const GL_NONE = 0x0;
const GL_LEFT = 0x0406;
//const GL_FRONT = 0x0404;
const GL_RIGHT = 0x0407;
//const GL_BACK = 0x0405;
//const GL_FRONT_AND_BACK = 0x0408;
const GL_FRONT_LEFT = 0x0400;
const GL_FRONT_RIGHT = 0x0401;
const GL_BACK_LEFT = 0x0402;
const GL_BACK_RIGHT = 0x0403;
const GL_AUX0 = 0x0409;
const GL_AUX1 = 0x040A;
const GL_AUX2 = 0x040B;
const GL_AUX3 = 0x040C;
const GL_COLOR_INDEX = 0x1900;
const GL_RED = 0x1903;
const GL_GREEN = 0x1904;
const GL_BLUE = 0x1905;
const GL_ALPHA = 0x1906;
const GL_LUMINANCE = 0x1909;
const GL_LUMINANCE_ALPHA = 0x190A;
const GL_ALPHA_BITS = 0x0D55;
const GL_RED_BITS = 0x0D52;
const GL_GREEN_BITS = 0x0D53;
const GL_BLUE_BITS = 0x0D54;
const GL_INDEX_BITS = 0x0D51;
const GL_SUBPIXEL_BITS = 0x0D50;
const GL_AUX_BUFFERS = 0x0C00;
const GL_READ_BUFFER = 0x0C02;
const GL_DRAW_BUFFER = 0x0C01;
const GL_DOUBLEBUFFER = 0x0C32;
const GL_STEREO = 0x0C33;
const GL_BITMAP = 0x1A00;
const GL_COLOR = 0x1800;
const GL_DEPTH = 0x1801;
const GL_STENCIL = 0x1802;
const GL_DITHER = 0x0BD0;
const GL_RGB = 0x1907;
const GL_RGBA = 0x1908;

/* Implementation limits */
const GL_MAX_LIST_NESTING = 0x0B31;
const GL_MAX_ATTRIB_STACK_DEPTH = 0x0D35;
const GL_MAX_MODELVIEW_STACK_DEPTH = 0x0D36;
const GL_MAX_NAME_STACK_DEPTH = 0x0D37;
const GL_MAX_PROJECTION_STACK_DEPTH = 0x0D38;
const GL_MAX_TEXTURE_STACK_DEPTH = 0x0D39;
const GL_MAX_EVAL_ORDER = 0x0D30;
const GL_MAX_LIGHTS = 0x0D31;
const GL_MAX_CLIP_PLANES = 0x0D32;
const GL_MAX_TEXTURE_SIZE = 0x0D33;
const GL_MAX_PIXEL_MAP_TABLE = 0x0D34;
const GL_MAX_VIEWPORT_DIMS = 0x0D3A;
const GL_MAX_CLIENT_ATTRIB_STACK_DEPTH = 0x0D3B;

/* Gets */
const GL_ATTRIB_STACK_DEPTH = 0x0BB0;
const GL_CLIENT_ATTRIB_STACK_DEPTH = 0x0BB1;
const GL_COLOR_CLEAR_VALUE = 0x0C22;
const GL_COLOR_WRITEMASK = 0x0C23;
const GL_CURRENT_INDEX = 0x0B01;
const GL_CURRENT_COLOR = 0x0B00;
const GL_CURRENT_NORMAL = 0x0B02;
const GL_CURRENT_RASTER_COLOR = 0x0B04;
const GL_CURRENT_RASTER_DISTANCE = 0x0B09;
const GL_CURRENT_RASTER_INDEX = 0x0B05;
const GL_CURRENT_RASTER_POSITION = 0x0B07;
const GL_CURRENT_RASTER_TEXTURE_COORDS = 0x0B06;
const GL_CURRENT_RASTER_POSITION_VALID = 0x0B08;
const GL_CURRENT_TEXTURE_COORDS = 0x0B03;
const GL_INDEX_CLEAR_VALUE = 0x0C20;
const GL_INDEX_MODE = 0x0C30;
const GL_INDEX_WRITEMASK = 0x0C21;
const GL_MODELVIEW_MATRIX = 0x0BA6;
const GL_MODELVIEW_STACK_DEPTH = 0x0BA3;
const GL_NAME_STACK_DEPTH = 0x0D70;
const GL_PROJECTION_MATRIX = 0x0BA7;
const GL_PROJECTION_STACK_DEPTH = 0x0BA4;
const GL_RENDER_MODE = 0x0C40;
const GL_RGBA_MODE = 0x0C31;
const GL_TEXTURE_MATRIX = 0x0BA8;
const GL_TEXTURE_STACK_DEPTH = 0x0BA5;
const GL_VIEWPORT = 0x0BA2;

/* Evaluators */
const GL_AUTO_NORMAL = 0x0D80;
const GL_MAP1_COLOR_4 = 0x0D90;
const GL_MAP1_GRID_DOMAIN = 0x0DD0;
const GL_MAP1_GRID_SEGMENTS = 0x0DD1;
const GL_MAP1_INDEX = 0x0D91;
const GL_MAP1_NORMAL = 0x0D92;
const GL_MAP1_TEXTURE_COORD_1 = 0x0D93;
const GL_MAP1_TEXTURE_COORD_2 = 0x0D94;
const GL_MAP1_TEXTURE_COORD_3 = 0x0D95;
const GL_MAP1_TEXTURE_COORD_4 = 0x0D96;
const GL_MAP1_VERTEX_3 = 0x0D97;
const GL_MAP1_VERTEX_4 = 0x0D98;
const GL_MAP2_COLOR_4 = 0x0DB0;
const GL_MAP2_GRID_DOMAIN = 0x0DD2;
const GL_MAP2_GRID_SEGMENTS = 0x0DD3;
const GL_MAP2_INDEX = 0x0DB1;
const GL_MAP2_NORMAL = 0x0DB2;
const GL_MAP2_TEXTURE_COORD_1 = 0x0DB3;
const GL_MAP2_TEXTURE_COORD_2 = 0x0DB4;
const GL_MAP2_TEXTURE_COORD_3 = 0x0DB5;
const GL_MAP2_TEXTURE_COORD_4 = 0x0DB6;
const GL_MAP2_VERTEX_3 = 0x0DB7;
const GL_MAP2_VERTEX_4 = 0x0DB8;
const GL_COEFF = 0x0A00;
const GL_DOMAIN = 0x0A02;
const GL_ORDER = 0x0A01;

/* Hints */
const GL_FOG_HINT = 0x0C54;
const GL_LINE_SMOOTH_HINT = 0x0C52;
const GL_PERSPECTIVE_CORRECTION_HINT = 0x0C50;
const GL_POINT_SMOOTH_HINT = 0x0C51;
const GL_POLYGON_SMOOTH_HINT = 0x0C53;
const GL_DONT_CARE = 0x1100;
const GL_FASTEST = 0x1101;
const GL_NICEST = 0x1102;

/* Scissor box */
const GL_SCISSOR_TEST = 0x0C11;
const GL_SCISSOR_BOX = 0x0C10;

/* Pixel Mode / Transfer */
const GL_MAP_COLOR = 0x0D10;
const GL_MAP_STENCIL = 0x0D11;
const GL_INDEX_SHIFT = 0x0D12;
const GL_INDEX_OFFSET = 0x0D13;
const GL_RED_SCALE = 0x0D14;
const GL_RED_BIAS = 0x0D15;
const GL_GREEN_SCALE = 0x0D18;
const GL_GREEN_BIAS = 0x0D19;
const GL_BLUE_SCALE = 0x0D1A;
const GL_BLUE_BIAS = 0x0D1B;
const GL_ALPHA_SCALE = 0x0D1C;
const GL_ALPHA_BIAS = 0x0D1D;
const GL_DEPTH_SCALE = 0x0D1E;
const GL_DEPTH_BIAS = 0x0D1F;
const GL_PIXEL_MAP_S_TO_S_SIZE = 0x0CB1;
const GL_PIXEL_MAP_I_TO_I_SIZE = 0x0CB0;
const GL_PIXEL_MAP_I_TO_R_SIZE = 0x0CB2;
const GL_PIXEL_MAP_I_TO_G_SIZE = 0x0CB3;
const GL_PIXEL_MAP_I_TO_B_SIZE = 0x0CB4;
const GL_PIXEL_MAP_I_TO_A_SIZE = 0x0CB5;
const GL_PIXEL_MAP_R_TO_R_SIZE = 0x0CB6;
const GL_PIXEL_MAP_G_TO_G_SIZE = 0x0CB7;
const GL_PIXEL_MAP_B_TO_B_SIZE = 0x0CB8;
const GL_PIXEL_MAP_A_TO_A_SIZE = 0x0CB9;
const GL_PIXEL_MAP_S_TO_S = 0x0C71;
const GL_PIXEL_MAP_I_TO_I = 0x0C70;
const GL_PIXEL_MAP_I_TO_R = 0x0C72;
const GL_PIXEL_MAP_I_TO_G = 0x0C73;
const GL_PIXEL_MAP_I_TO_B = 0x0C74;
const GL_PIXEL_MAP_I_TO_A = 0x0C75;
const GL_PIXEL_MAP_R_TO_R = 0x0C76;
const GL_PIXEL_MAP_G_TO_G = 0x0C77;
const GL_PIXEL_MAP_B_TO_B = 0x0C78;
const GL_PIXEL_MAP_A_TO_A = 0x0C79;
const GL_PACK_ALIGNMENT = 0x0D05;
const GL_PACK_LSB_FIRST = 0x0D01;
const GL_PACK_ROW_LENGTH = 0x0D02;
const GL_PACK_SKIP_PIXELS = 0x0D04;
const GL_PACK_SKIP_ROWS = 0x0D03;
const GL_PACK_SWAP_BYTES = 0x0D00;
const GL_UNPACK_ALIGNMENT = 0x0CF5;
const GL_UNPACK_LSB_FIRST = 0x0CF1;
const GL_UNPACK_ROW_LENGTH = 0x0CF2;
const GL_UNPACK_SKIP_PIXELS = 0x0CF4;
const GL_UNPACK_SKIP_ROWS = 0x0CF3;
const GL_UNPACK_SWAP_BYTES = 0x0CF0;
const GL_ZOOM_X = 0x0D16;
const GL_ZOOM_Y = 0x0D17;

/* Texture mapping */
const GL_TEXTURE_ENV = 0x2300;
const GL_TEXTURE_ENV_MODE = 0x2200;
const GL_TEXTURE_1D = 0x0DE0;
const GL_TEXTURE_2D = 0x0DE1;
const GL_TEXTURE_WRAP_S = 0x2802;
const GL_TEXTURE_WRAP_T = 0x2803;
const GL_TEXTURE_MAG_FILTER = 0x2800;
const GL_TEXTURE_MIN_FILTER = 0x2801;
const GL_TEXTURE_ENV_COLOR = 0x2201;
const GL_TEXTURE_GEN_S = 0x0C60;
const GL_TEXTURE_GEN_T = 0x0C61;
const GL_TEXTURE_GEN_MODE = 0x2500;
const GL_TEXTURE_BORDER_COLOR = 0x1004;
const GL_TEXTURE_WIDTH = 0x1000;
const GL_TEXTURE_HEIGHT = 0x1001;
const GL_TEXTURE_BORDER = 0x1005;
const GL_TEXTURE_COMPONENTS = 0x1003;
const GL_TEXTURE_RED_SIZE = 0x805C;
const GL_TEXTURE_GREEN_SIZE = 0x805D;
const GL_TEXTURE_BLUE_SIZE = 0x805E;
const GL_TEXTURE_ALPHA_SIZE = 0x805F;
const GL_TEXTURE_LUMINANCE_SIZE = 0x8060;
const GL_TEXTURE_INTENSITY_SIZE = 0x8061;
const GL_NEAREST_MIPMAP_NEAREST = 0x2700;
const GL_NEAREST_MIPMAP_LINEAR = 0x2702;
const GL_LINEAR_MIPMAP_NEAREST = 0x2701;
const GL_LINEAR_MIPMAP_LINEAR = 0x2703;
const GL_OBJECT_LINEAR = 0x2401;
const GL_OBJECT_PLANE = 0x2501;
const GL_EYE_LINEAR = 0x2400;
const GL_EYE_PLANE = 0x2502;
const GL_SPHERE_MAP = 0x2402;
const GL_DECAL = 0x2101;
const GL_MODULATE = 0x2100;
const GL_NEAREST = 0x2600;
const GL_REPEAT = 0x2901;
const GL_CLAMP = 0x2900;
const GL_S = 0x2000;
const GL_T = 0x2001;
const GL_R = 0x2002;
const GL_Q = 0x2003;
const GL_TEXTURE_GEN_R = 0x0C62;
const GL_TEXTURE_GEN_Q = 0x0C63;

/* Utility */
const GL_VENDOR = 0x1F00;
const GL_RENDERER = 0x1F01;
const GL_VERSION = 0x1F02;
const GL_EXTENSIONS = 0x1F03;

/* Errors */
const GL_NO_ERROR = 0x0;
const GL_INVALID_VALUE = 0x0501;
const GL_INVALID_ENUM = 0x0500;
const GL_INVALID_OPERATION = 0x0502;
const GL_STACK_OVERFLOW = 0x0503;
const GL_STACK_UNDERFLOW = 0x0504;
const GL_OUT_OF_MEMORY = 0x0505;

/* glPush/PopAttrib bits */
const GL_CURRENT_BIT = 0x00000001;
const GL_POINT_BIT = 0x00000002;
const GL_LINE_BIT = 0x00000004;
const GL_POLYGON_BIT = 0x00000008;
const GL_POLYGON_STIPPLE_BIT = 0x00000010;
const GL_PIXEL_MODE_BIT = 0x00000020;
const GL_LIGHTING_BIT = 0x00000040;
const GL_FOG_BIT = 0x00000080;
const GL_DEPTH_BUFFER_BIT = 0x00000100;
const GL_ACCUM_BUFFER_BIT = 0x00000200;
const GL_STENCIL_BUFFER_BIT = 0x00000400;
const GL_VIEWPORT_BIT = 0x00000800;
const GL_TRANSFORM_BIT = 0x00001000;
const GL_ENABLE_BIT = 0x00002000;
const GL_COLOR_BUFFER_BIT = 0x00004000;
const GL_HINT_BIT = 0x00008000;
const GL_EVAL_BIT = 0x00010000;
const GL_LIST_BIT = 0x00020000;
const GL_TEXTURE_BIT = 0x00040000;
const GL_SCISSOR_BIT = 0x00080000;
const GL_ALL_ATTRIB_BITS = 0x000FFFFF;


extern (System){
  /* Wgl functions 
  BOOL function(void*,void*) wglCopyContext;
  void* function(void*) wglCreateContext;
  void* function(void*,int) wglCreateLayerContext;
  BOOL function(void*) wglDeleteContext;
  BOOL function(void*,int,int,UINT,LAYERPLANEDESCRIPTOR*) wglDescribeLayerPlane;
  void* function() wglGetCurrentContext;
  void* function() wglGetCurrentDC;
  int function(void*,int,int,int,COLORREF*) wglGetLayerPaletteEntries;
  FARPROC function(LPCSTR) wglGetProcAddress;
  BOOL function(void*,void*) wglMakeCurrent;
  BOOL function(void*,int,BOOL) wglRealizeLayerPalette;
  int function(void*,int,int,int,COLORREF*) wglSetLayerPaletteEntries;
  BOOL function(void*,void*) wglShareLists;
  BOOL function(void*,UINT) wglSwapLayerBuffers;
  BOOL function(void*,DWORD,DWORD,DWORD) wglUseFontBitmapsA;
  BOOL function(void*,DWORD,DWORD,DWORD,FLOAT,FLOAT,int,GLYPHMETRICSFLOAT*) wglUseFontOutlinesA;
  BOOL function(void*,DWORD,DWORD,DWORD) wglUseFontBitmapsW;
  BOOL function(void*,DWORD,DWORD,DWORD,FLOAT,FLOAT,int,GLYPHMETRICSFLOAT*) wglUseFontOutlinesW;
  alias wglUseFontBitmapsA    wglUseFontBitmaps;
  alias wglUseFontOutlinesA   wglUseFontOutlines;
  */

  /* 1.0 functions */
  void function(GLfloat c) glClearIndex;
  void function(GLclampf,GLclampf,GLclampf,GLclampf) glClearColor;
  void function(GLbitfield) glClear;
  void function(GLuint) glIndexMask;
  void function(GLboolean,GLboolean,GLboolean,GLboolean) glColorMask;
  void function(GLenum,GLclampf) glAlphaFunc;
  void function(GLenum,GLenum) glBlendFunc;
  void function(GLenum) glLogicOp;
  void function(GLenum) glCullFace;
  void function(GLenum) glFrontFace;
  void function(GLfloat) glPointSize;
  void function(GLfloat) glLineWidth;
  void function(GLint,GLushort) glLineStipple;
  void function(GLenum,GLenum) glPolygonMode;
  void function(GLfloat,GLfloat) glPolygonOffset;
  void function(GLubyte*) glPolygonStipple;
  void function(GLubyte*) glGetPolygonStipple;
  void function(GLboolean) glEdgeFlag;
  void function(GLboolean*)glEdgeFlagv;
  void function(GLint,GLint,GLsizei,GLsizei) glScissor;
  void function(GLenum,GLdouble*) glClipPlane;
  void function(GLenum,GLdouble*) glGetClipPlane;
  void function(GLenum) glDrawBuffer;
  void function(GLenum) glReadBuffer;
  void function(GLenum) glEnable;
  void function(GLenum) glDisable;
  GLboolean function(GLenum) glIsEnabled;
  void function(GLenum) glEnableClientState;
  void function(GLenum) glDisableClientState;
  void function(GLenum,GLboolean*) glGetBooleanv;
  void function(GLenum,GLdouble*) glGetDoublev;
  void function(GLenum,GLfloat*) glGetFloatv;
  void function(GLenum,GLint*) glGetIntegerv;
  void function(GLbitfield) glPushAttrib;
  void function() glPopAttrib;
  void function(GLbitfield) glPushClientAttrib;
  void function() glPopClientAttrib;
  GLint function(GLenum) glRenderMode;
  GLenum function() glGetError;
  GLchar* function(GLenum) glGetString;
  void function() glFinish;
  void function() glFlush;
  void function(GLenum,GLenum) glHint;

  void function(GLclampd) glClearDepth;
  void function(GLenum) glDepthFunc;
  void function(GLboolean) glDepthMask;
  void function(GLclampd,GLclampd) glDepthRange;

  void function(GLfloat,GLfloat,GLfloat,GLfloat) glClearAccum;
  void function(GLenum,GLfloat) glAccum;

  void function(GLenum) glMatrixMode;
  void function(GLdouble,GLdouble,GLdouble,GLdouble,GLdouble,GLdouble) glOrtho;
  void function(GLdouble,GLdouble,GLdouble,GLdouble,GLdouble,GLdouble) glFrustum;
  void function(GLint,GLint,GLsizei,GLsizei) glViewport;
  void function() glPushMatrix;
  void function() glPopMatrix;
  void function() glLoadIdentity;
  void function(GLdouble*) glLoadMatrixd;
  void function(GLfloat*) glLoadMatrixf;
  void function(GLdouble*) glMultMatrixd;
  void function(GLfloat*) glMultMatrixf;
  void function(GLdouble,GLdouble,GLdouble,GLdouble) glRotated;
  void function(GLfloat,GLfloat,GLfloat,GLfloat) glRotatef;
  void function(GLdouble,GLdouble,GLdouble) glScaled;
  void function(GLfloat,GLfloat,GLfloat) glScalef;
  void function(GLdouble,GLdouble,GLdouble) glTranslated;
  void function(GLfloat,GLfloat,GLfloat) glTranslatef;

  GLboolean function(GLuint) glIsList;
  void function(GLuint,GLsizei) glDeleteLists;
  GLuint function(GLsizei) glGenLists;
  void function(GLuint,GLenum) glNewList;
  void function() glEndList;
  void function(GLuint) glCallList;
  void function(GLsizei,GLenum,GLvoid*) glCallLists;
  void function(GLuint) glListBase;

  void function(GLenum) glBegin;
  void function() glEnd;
  void function(GLdouble,GLdouble) glVertex2d;
  void function(GLfloat,GLfloat) glVertex2f;
  void function(GLint,GLint) glVertex2i;
  void function(GLshort,GLshort) glVertex2s;
  void function(GLdouble,GLdouble,GLdouble) glVertex3d;
  void function(GLfloat,GLfloat,GLfloat) glVertex3f;
  void function(GLint,GLint,GLint) glVertex3i;
  void function(GLshort,GLshort,GLshort) glVertex3s;
  void function(GLdouble,GLdouble,GLdouble,GLdouble) glVertex4d;
  void function(GLfloat,GLfloat,GLfloat,GLfloat) glVertex4f;
  void function(GLint,GLint,GLint,GLint) glVertex4i;
  void function(GLshort,GLshort,GLshort,GLshort) glVertex4s;
  void function(GLdouble*) glVertex2dv;
  void function(GLfloat*) glVertex2fv;
  void function(GLint*) glVertex2iv;
  void function(GLshort*) glVertex2sv;
  void function(GLdouble*) glVertex3dv;
  void function(GLfloat*) glVertex3fv;
  void function(GLint*) glVertex3iv;
  void function(GLshort*) glVertex3sv;
  void function(GLdouble*) glVertex4dv;
  void function(GLfloat*) glVertex4fv;
  void function(GLint*) glVertex4iv;
  void function(GLshort*) glVertex4sv;
  void function(GLbyte,GLbyte,GLbyte) glNormal3b;
  void function(GLdouble,GLdouble,GLdouble) glNormal3d;
  void function(GLfloat,GLfloat,GLfloat) glNormal3f;
  void function(GLint,GLint,GLint) glNormal3i;
  void function(GLshort,GLshort,GLshort) glNormal3s;
  void function(GLbyte*) glNormal3bv;
  void function(GLdouble*) glNormal3dv;
  void function(GLfloat*) glNormal3fv;
  void function(GLint*) glNormal3iv;
  void function(GLshort*) glNormal3sv;
  void function(GLdouble) glIndexd;
  void function(GLfloat) glIndexf;
  void function(GLint) glIndexi;
  void function(GLshort) glIndexs;
  void function(GLubyte) glIndexub;
  void function(GLdouble*) glIndexdv;
  void function(GLfloat*) glIndexfv;
  void function(GLint*) glIndexiv;
  void function(GLshort*) glIndexsv;
  void function(GLubyte*) glIndexubv;
  void function(GLbyte,GLbyte,GLbyte) glColor3b;
  void function(GLdouble,GLdouble,GLdouble) glColor3d;
  void function(GLfloat,GLfloat,GLfloat) glColor3f;
  void function(GLint,GLint,GLint) glColor3i;
  void function(GLshort,GLshort,GLshort) glColor3s;
  void function(GLubyte,GLubyte,GLubyte) glColor3ub;
  void function(GLuint,GLuint,GLuint) glColor3ui;
  void function(GLushort,GLushort,GLushort) glColor3us;
  void function(GLbyte,GLbyte,GLbyte,GLbyte) glColor4b;
  void function(GLdouble,GLdouble,GLdouble,GLdouble) glColor4d;
  void function(GLfloat,GLfloat,GLfloat,GLfloat) glColor4f;
  void function(GLint,GLint,GLint,GLint) glColor4i;
  void function(GLshort,GLshort,GLshort,GLshort) glColor4s;
  void function(GLubyte,GLubyte,GLubyte,GLubyte) glColor4ub;
  void function(GLuint,GLuint,GLuint,GLuint) glColor4ui;
  void function(GLushort,GLushort,GLushort,GLushort) glColor4us;
  void function(GLbyte*) glColor3bv;
  void function(GLdouble*) glColor3dv;
  void function(GLfloat*) glColor3fv;
  void function(GLint*) glColor3iv;
  void function(GLshort*) glColor3sv;
  void function(GLubyte*) glColor3ubv;
  void function(GLuint*) glColor3uiv;
  void function(GLushort*) glColor3usv;
  void function(GLbyte*) glColor4bv;
  void function(GLdouble*) glColor4dv;
  void function(GLfloat*) glColor4fv;
  void function(GLint*) glColor4iv;
  void function(GLshort*) glColor4sv;
  void function(GLubyte*) glColor4ubv;
  void function(GLuint*) glColor4uiv;
  void function(GLushort) glColor4usv;
  void function(GLdouble) glTexCoord1d;
  void function(GLfloat) glTexCoord1f;
  void function(GLint) glTexCoord1i;
  void function(GLshort) glTexCoord1s;
  void function(GLdouble,GLdouble) glTexCoord2d;
  void function(GLfloat,GLfloat) glTexCoord2f;
  void function(GLint,GLint) glTexCoord2i;
  void function(GLshort,GLshort) glTexCoord2s;
  void function(GLdouble,GLdouble,GLdouble) glTexCoord3d;
  void function(GLfloat,GLfloat,GLfloat) glTexCoord3f;
  void function(GLint,GLint,GLint) glTexCoord3i;
  void function(GLshort,GLshort,GLshort) glTexCoord3s;
  void function(GLdouble,GLdouble,GLdouble,GLdouble) glTexCoord4d;
  void function(GLfloat,GLfloat,GLfloat,GLfloat) glTexCoord4f;
  void function(GLint,GLint,GLint,GLint) glTexCoord4i;
  void function(GLshort,GLshort,GLshort,GLshort) glTexCoord4s;
  void function(GLdouble*) glTexCoord1dv;
  void function(GLfloat*) glTexCoord1fv;
  void function(GLint*) glTexCoord1iv;
  void function(GLshort*) glTexCoord1sv;
  void function(GLdouble*) glTexCoord2dv;
  void function(GLfloat*) glTexCoord2fv;
  void function(GLint*) glTexCoord2iv;
  void function(GLshort*) glTexCoord2sv;
  void function(GLdouble*) glTexCoord3dv;
  void function(GLfloat*) glTexCoord3fv;
  void function(GLint*) glTexCoord3iv;
  void function(GLshort*) glTexCoord3sv;
  void function(GLdouble*) glTexCoord4dv;
  void function(GLfloat*) glTexCoord4fv;
  void function(GLint*) glTexCoord4iv;
  void function(GLshort*) glTexCoord4sv;
  void function(GLdouble,GLdouble) glRasterPos2d;
  void function(GLfloat,GLfloat) glRasterPos2f;
  void function(GLint,GLint) glRasterPos2i;
  void function(GLshort,GLshort) glRasterPos2s;
  void function(GLdouble,GLdouble,GLdouble) glRasterPos3d;
  void function(GLfloat,GLfloat,GLfloat) glRasterPos3f;
  void function(GLint,GLint,GLint) glRasterPos3i;
  void function(GLshort,GLshort,GLshort) glRasterPos3s;
  void function(GLdouble,GLdouble,GLdouble,GLdouble) glRasterPos4d;
  void function(GLfloat,GLfloat,GLfloat,GLfloat) glRasterPos4f;
  void function(GLint,GLint,GLint,GLint) glRasterPos4i;
  void function(GLshort,GLshort,GLshort,GLshort) glRasterPos4s;
  void function(GLdouble*) glRasterPos2dv;
  void function(GLfloat*) glRasterPos2fv;
  void function(GLint*) glRasterPos2iv;
  void function(GLshort*) glRasterPos2sv;
  void function(GLdouble*) glRasterPos3dv;
  void function(GLfloat*) glRasterPos3fv;
  void function(GLint*) glRasterPos3iv;
  void function(GLshort*) glRasterPos3sv;
  void function(GLdouble*) glRasterPos4dv;
  void function(GLfloat*) glRasterPos4fv;
  void function(GLint*) glRasterPos4iv;
  void function(GLshort*) glRasterPos4sv;
  void function(GLdouble,GLdouble,GLdouble,GLdouble) glRectd;
  void function(GLfloat,GLfloat,GLfloat,GLfloat) glRectf;
  void function(GLint,GLint,GLint,GLint) glRecti;
  void function(GLshort,GLshort,GLshort,GLshort) glRects;
  void function(GLdouble*) glRectdv;
  void function(GLfloat*) glRectfv;
  void function(GLint*) glRectiv;
  void function(GLshort*) glRectsv;

  void function(GLenum) glShadeModel;
  void function(GLenum,GLenum,GLfloat) glLightf;
  void function(GLenum,GLenum,GLint) glLighti;
  void function(GLenum,GLenum,GLfloat*) glLightfv;
  void function(GLenum,GLenum,GLint*) glLightiv;
  void function(GLenum,GLenum,GLfloat*) glGetLightfv;
  void function(GLenum,GLenum,GLint*) glGetLightiv;
  void function(GLenum,GLfloat) glLightModelf;
  void function(GLenum,GLint) glLightModeli;
  void function(GLenum,GLfloat*) glLightModelfv;
  void function(GLenum,GLint*) glLightModeliv;
  void function(GLenum,GLenum,GLfloat) glMaterialf;
  void function(GLenum,GLenum,GLint) glMateriali;
  void function(GLenum,GLenum,GLfloat*) glMaterialfv;
  void function(GLenum,GLenum,GLint*) glMaterialiv;
  void function(GLenum,GLenum,GLfloat*) glGetMaterialfv;
  void function(GLenum,GLenum,GLint*) glGetMaterialiv;
  void function(GLenum,GLenum) glColorMaterial;

  void function(GLfloat,GLfloat) glPixelZoom;
  void function(GLenum,GLfloat) glPixelStoref;
  void function(GLenum,GLint) glPixelStorei;
  void function(GLenum,GLfloat) glPixelTransferf;
  void function(GLenum,GLint) glPixelTransferi;
  void function(GLenum,GLint,GLfloat*) glPixelMapfv;
  void function(GLenum,GLint,GLuint*) glPixelMapuiv;
  void function(GLenum,GLint,GLushort*) glPixelMapusv;
  void function(GLenum,GLfloat*) glGetPixelMapfv;
  void function(GLenum,GLuint*) glGetPixelMapuiv;
  void function(GLenum,GLushort*) glGetPixelMapusv;
  void function(GLsizei,GLsizei,GLfloat,GLfloat,GLfloat,GLfloat,GLubyte*) glBitmap;
  void function(GLint,GLint,GLsizei,GLsizei,GLenum,GLenum,GLvoid*) glReadPixels;
  void function(GLsizei,GLsizei,GLenum,GLenum,GLvoid*) glDrawPixels;
  void function(GLint,GLint,GLsizei,GLsizei,GLenum) glCopyPixels;

  void function(GLenum,GLint,GLuint) glStencilFunc;
  void function(GLuint) glStencilMask;
  void function(GLenum,GLenum,GLenum) glStencilOp;
  void function(GLint) glClearStencil;

  void function(GLenum,GLenum,GLdouble) glTexGend;
  void function(GLenum,GLenum,GLfloat) glTexGenf;
  void function(GLenum,GLenum,GLint) glTexGeni;
  void function(GLenum,GLenum,GLdouble*) glTexGendv;
  void function(GLenum,GLenum,GLfloat*) glTexGenfv;
  void function(GLenum,GLenum,GLint*) glTexGeniv;
  void function(GLenum,GLenum,GLdouble*) glGetTexGendv;
  void function(GLenum,GLenum,GLfloat*) glGetTexGenfv;
  void function(GLenum,GLenum,GLint*) glGetTexGeniv;
  void function(GLenum,GLenum,GLfloat) glTexEnvf;
  void function(GLenum,GLenum,GLint) glTexEnvi;
  void function(GLenum,GLenum,GLfloat*) glTexEnvfv;
  void function(GLenum,GLenum,GLint*) glTexEnviv;
  void function(GLenum,GLenum,GLfloat*) glGetTexEnvfv;
  void function(GLenum,GLenum,GLint*) glGetTexEnviv;
  void function(GLenum,GLenum,GLfloat) glTexParameterf;
  void function(GLenum,GLenum,GLint) glTexParameteri;
  void function(GLenum,GLenum,GLfloat*) glTexParameterfv;
  void function(GLenum,GLenum,GLint*) glTexParameteriv;
  void function(GLenum,GLenum,GLfloat*) glGetTexParameterfv;
  void function(GLenum,GLenum,GLint*) glGetTexParameteriv;
  void function(GLenum,GLint,GLenum,GLfloat*) glGetTexLevelParameterfv;
  void function(GLenum,GLint,GLenum,GLint*) glGetTexLevelParameteriv;
  void function(GLenum,GLint,GLint,GLsizei,GLint,GLenum,GLenum,GLvoid*) glTexImage1D;
  void function(GLenum,GLint,GLint,GLsizei,GLsizei,GLint,GLenum,GLenum,GLvoid*) glTexImage2D;
  void function(GLenum,GLint,GLenum,GLenum,GLvoid*) glGetTexImage;

  void function(GLenum,GLdouble,GLdouble,GLint,GLint,GLdouble*) glMap1d;
  void function(GLenum,GLfloat,GLfloat,GLint,GLint,GLfloat*) glMap1f;
  void function(GLenum,GLdouble,GLdouble,GLint,GLint,GLdouble,GLdouble,GLint,GLint,GLdouble*) glMap2d;
  void function(GLenum,GLfloat,GLfloat,GLint,GLint,GLfloat,GLfloat,GLint,GLint,GLfloat*) glMap2f;
  void function(GLenum,GLenum,GLdouble*) glGetMapdv;
  void function(GLenum,GLenum,GLfloat*) glGetMapfv;
  void function(GLenum,GLenum,GLint*) glGetMapiv;
  void function(GLdouble) glEvalCoord1d;
  void function(GLfloat) glEvalCoord1f;
  void function(GLdouble*) glEvalCoord1dv;
  void function(GLfloat*) glEvalCoord1fv;
  void function(GLdouble,GLdouble) glEvalCoord2d;
  void function(GLfloat,GLfloat) glEvalCoord2f;
  void function(GLdouble*) glEvalCoord2dv;
  void function(GLfloat*) glEvalCoord2fv;
  void function(GLint,GLdouble,GLdouble) glMapGrid1d;
  void function(GLint,GLfloat,GLfloat) glMapGrid1f;
  void function(GLint,GLdouble,GLdouble,GLint,GLdouble,GLdouble) glMapGrid2d;
  void function(GLint,GLfloat,GLfloat,GLint,GLfloat,GLfloat) glMapGrid2f;
  void function(GLint) glEvalPoint1;
  void function(GLint,GLint) glEvalPoint2;
  void function(GLenum,GLint,GLint) glEvalMesh1;
  void function(GLenum,GLint,GLint,GLint,GLint) glEvalMesh2;

  void function(GLenum,GLfloat) glFogf;
  void function(GLenum,GLint) glFogi;
  void function(GLenum,GLfloat*) glFogfv;
  void function(GLenum,GLint*) glFogiv;

  void function(GLsizei,GLenum,GLfloat*) glFeedbackBuffer;
  void function(GLfloat) glPassThrough;
  void function(GLsizei,GLuint*) glSelectBuffer;
  void function() glInitNames;
  void function(GLuint) glLoadName;
  void function(GLuint) glPushName;
  void function() glPopName;
}