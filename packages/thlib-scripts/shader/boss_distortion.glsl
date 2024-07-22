#version 410 core
// 引擎参数
uniform sampler2D screen_texture;

uniform engine_data
{
    vec4 screen_texture_size; // 纹理大小
    vec4 viewport;            // 视口
};

// 用户传递的参数

uniform user_data
{
    vec4 center_pos;   // 指定效果的中心坐标
    vec4 effect_color; // 指定效果的中心颜色,着色时使用colorburn算法
    vec4 effect_param; // 多个参数：effect_size 指定效果的影响大小、effect_arg 变形系数、effect_color_size 颜色的扩散大小、timer 外部计时器
};
#define effect_size       effect_param.x
#define effect_arg        effect_param.y
#define effect_color_size effect_param.z
#define timer             effect_param.w

// If using ExPlus PostEffect() syntax

// uniform user_data
// {
//     float centerX;
//     float centerY;
//     float size;
//     float colorsize;
//     float arg;
//     float timer;
//     vec4  color;
// };
// #define effect_size         size
// #define effect_arg          arg
// #define effect_color        color
// #define effect_color_size   colorsize

// 不变量

const float PI    = 3.14159265f;
const float inner = 1.0f;
const float cb_64 = (64.0f / 255.0f);

// 方法

vec2 Distortion(vec2 xy, vec2 delta, float delta_len)
{
	float k = delta_len / effect_size;
	float p = pow(1.0f - k, 0.75f);//pow((k - 1.0f), 0.75f);
	float arg = effect_arg * p;
	vec2 delta1 = vec2(sin(1.75f * 2.0f * PI * delta.x + 0.05f * delta_len + timer / 20.0f), sin(1.75f * 2.0f * PI * delta.y + 0.05f * delta_len + timer / 24.0f)); // 1.75f 此项越高，波纹越“破碎”
	float delta2 = arg * sin(0.005f * 2.0f * PI * delta_len+ timer / 40.0f); // 0.005f 此项越高，波纹越密
	return delta1 * delta2; // delta1：方向向量，delta2：向量长度，即返回像素移动的方向和距离
}

// 主函数

layout(location = 0) in vec4 sxy;
layout(location = 1) in vec4 pos;
layout(location = 2) in vec2 uv;
layout(location = 3) in vec4 col;

layout(location = 0) out vec4 col_out;

void main()
{
    vec2 xy = gl_FragCoord.xy;  // Screen Location
    if (xy.x < viewport.x || xy.x > viewport.z || xy.y < viewport.y || xy.y > viewport.w)
    {
        discard; // 抛弃不需要的像素，防止意外覆盖画面
    }
    vec2 uv2 = uv;
    vec2 delta = xy - center_pos.xy;  // 计算效果中心到纹理采样点的向量
    float delta_len = length(delta);
    delta = normalize(delta);
    if (delta_len <= effect_size)
    {
        vec2 distDelta = Distortion(xy, delta, delta_len);
        vec2 resultxy = xy + distDelta;
        if (resultxy.x > (viewport.x + inner) && resultxy.x < (viewport.z - inner) && resultxy.y > (viewport.y + inner) && resultxy.y < (viewport.w - inner))
        {
            uv2 += distDelta / screen_texture_size.xy;
        }
        else
        {
            uv2 = uv;
        }
    }
    
    vec4 tex_color = texture(screen_texture, uv2); // 对纹理进行采样
    if (delta_len <= effect_color_size)
    {
        // 扭曲着色
        float k = delta_len / effect_color_size;
        float ak = effect_color.a * pow((1.0f - k), 1.2f);
        vec4 processed_color = vec4(max(cb_64, effect_color.r), max(cb_64, effect_color.g), max(cb_64, effect_color.b), effect_color.a);
        vec4 result_color = tex_color - ((1.0f - tex_color) * (1.0f - processed_color)) / processed_color;
        tex_color.r = ak * result_color.r + (1.0f - ak) * tex_color.r;
        tex_color.g = ak * result_color.g + (1.0f - ak) * tex_color.g;
        tex_color.b = ak * result_color.b + (1.0f - ak) * tex_color.b;
    }
    tex_color.a = 1.0f;

    col_out = tex_color;
}
