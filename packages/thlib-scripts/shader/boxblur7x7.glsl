#version 410 core
// ----------------------------------------
// 7x7 均值模糊 code by Xiliusha
// 代码移植 by 璀境石
// ----------------------------------------

// 引擎设置的参数，不可修改

uniform sampler2D screen_texture;

uniform engine_data
{
    vec4 screen_texture_size; // 纹理大小
    vec4 viewport;            // 视口
};

// 用户传递的浮点参数
// 由多个 float4 组成，且 float4 是最小单元，最多可传递 8 个 float4

uniform user_data
{
    float4 user_data_0;
};

// 用户传递的纹理和采样器参数，可用槽位 0 到 3

// 为了方便使用，可以定义一些宏

#define screenSize screen_texture_size.xy
// 采样半径（单位：游戏内单位长度，即和游戏坐标系相关）
#define radiu user_data_0.x

// 不变量

const float border_inner = 1.0f;

// 方法

vec2 ClampSamplePoint(vec2 pos)
{
    pos.x = clamp(pos.x, viewport.x + border_inner, viewport.z - border_inner);
    pos.y = clamp(pos.y, viewport.y + border_inner, viewport.w - border_inner);
    return pos;
}

vec4 BoxBlur7x7(vec2 uv, float r)
{
    vec2 xy = uv * screen_texture_size.xy;
    // 生成采样点
    vec2 sample_point_1  = ClampSamplePoint(xy + vec2(-3.0f * r,  3.0f * r));
    vec2 sample_point_2  = ClampSamplePoint(xy + vec2(-2.0f * r,  3.0f * r));
    vec2 sample_point_3  = ClampSamplePoint(xy + vec2(-1.0f * r,  3.0f * r));
    vec2 sample_point_4  = ClampSamplePoint(xy + vec2( 0.0f * r,  3.0f * r));
    vec2 sample_point_5  = ClampSamplePoint(xy + vec2( 1.0f * r,  3.0f * r));
    vec2 sample_point_6  = ClampSamplePoint(xy + vec2(-2.0f * r,  3.0f * r));
    vec2 sample_point_7  = ClampSamplePoint(xy + vec2(-3.0f * r,  3.0f * r));
    vec2 sample_point_8  = ClampSamplePoint(xy + vec2(-3.0f * r,  2.0f * r));
    vec2 sample_point_9  = ClampSamplePoint(xy + vec2(-2.0f * r,  2.0f * r));
    vec2 sample_point_10 = ClampSamplePoint(xy + vec2(-1.0f * r,  2.0f * r));
    vec2 sample_point_11 = ClampSamplePoint(xy + vec2( 0.0f * r,  2.0f * r));
    vec2 sample_point_12 = ClampSamplePoint(xy + vec2( 1.0f * r,  2.0f * r));
    vec2 sample_point_13 = ClampSamplePoint(xy + vec2(-2.0f * r,  2.0f * r));
    vec2 sample_point_14 = ClampSamplePoint(xy + vec2(-3.0f * r,  2.0f * r));
    vec2 sample_point_15 = ClampSamplePoint(xy + vec2(-3.0f * r,  1.0f * r));
    vec2 sample_point_16 = ClampSamplePoint(xy + vec2(-2.0f * r,  1.0f * r));
    vec2 sample_point_17 = ClampSamplePoint(xy + vec2(-1.0f * r,  1.0f * r));
    vec2 sample_point_18 = ClampSamplePoint(xy + vec2( 0.0f * r,  1.0f * r));
    vec2 sample_point_19 = ClampSamplePoint(xy + vec2( 1.0f * r,  1.0f * r));
    vec2 sample_point_20 = ClampSamplePoint(xy + vec2(-2.0f * r,  1.0f * r));
    vec2 sample_point_21 = ClampSamplePoint(xy + vec2(-3.0f * r,  1.0f * r));
    vec2 sample_point_22 = ClampSamplePoint(xy + vec2(-3.0f * r,  0.0f * r));
    vec2 sample_point_23 = ClampSamplePoint(xy + vec2(-2.0f * r,  0.0f * r));
    vec2 sample_point_24 = ClampSamplePoint(xy + vec2(-1.0f * r,  0.0f * r));
    vec2 sample_point_25 = ClampSamplePoint(xy + vec2( 0.0f * r,  0.0f * r));
    vec2 sample_point_26 = ClampSamplePoint(xy + vec2( 1.0f * r,  0.0f * r));
    vec2 sample_point_27 = ClampSamplePoint(xy + vec2(-2.0f * r,  0.0f * r));
    vec2 sample_point_28 = ClampSamplePoint(xy + vec2(-3.0f * r,  0.0f * r));
    vec2 sample_point_29 = ClampSamplePoint(xy + vec2(-3.0f * r, -1.0f * r));
    vec2 sample_point_30 = ClampSamplePoint(xy + vec2(-2.0f * r, -1.0f * r));
    vec2 sample_point_31 = ClampSamplePoint(xy + vec2(-1.0f * r, -1.0f * r));
    vec2 sample_point_32 = ClampSamplePoint(xy + vec2( 0.0f * r, -1.0f * r));
    vec2 sample_point_33 = ClampSamplePoint(xy + vec2( 1.0f * r, -1.0f * r));
    vec2 sample_point_34 = ClampSamplePoint(xy + vec2(-2.0f * r, -1.0f * r));
    vec2 sample_point_35 = ClampSamplePoint(xy + vec2(-3.0f * r, -1.0f * r));
    vec2 sample_point_36 = ClampSamplePoint(xy + vec2(-3.0f * r, -2.0f * r));
    vec2 sample_point_37 = ClampSamplePoint(xy + vec2(-2.0f * r, -2.0f * r));
    vec2 sample_point_38 = ClampSamplePoint(xy + vec2(-1.0f * r, -2.0f * r));
    vec2 sample_point_39 = ClampSamplePoint(xy + vec2( 0.0f * r, -2.0f * r));
    vec2 sample_point_40 = ClampSamplePoint(xy + vec2( 1.0f * r, -2.0f * r));
    vec2 sample_point_41 = ClampSamplePoint(xy + vec2(-2.0f * r, -2.0f * r));
    vec2 sample_point_42 = ClampSamplePoint(xy + vec2(-3.0f * r, -2.0f * r));
    vec2 sample_point_43 = ClampSamplePoint(xy + vec2(-3.0f * r, -3.0f * r));
    vec2 sample_point_44 = ClampSamplePoint(xy + vec2(-2.0f * r, -3.0f * r));
    vec2 sample_point_45 = ClampSamplePoint(xy + vec2(-1.0f * r, -3.0f * r));
    vec2 sample_point_46 = ClampSamplePoint(xy + vec2( 0.0f * r, -3.0f * r));
    vec2 sample_point_47 = ClampSamplePoint(xy + vec2( 1.0f * r, -3.0f * r));
    vec2 sample_point_48 = ClampSamplePoint(xy + vec2(-2.0f * r, -3.0f * r));
    vec2 sample_point_49 = ClampSamplePoint(xy + vec2(-3.0f * r, -3.0f * r));
    // 对纹理采样
    vec2 uv_scale = vec2(1.0f, 1.0f) / screen_texture_size.xy;
    vec4 sample_color_1  = texture(screen_texture, sample_point_1  * uv_scale);
    vec4 sample_color_2  = texture(screen_texture, sample_point_2  * uv_scale);
    vec4 sample_color_3  = texture(screen_texture, sample_point_3  * uv_scale);
    vec4 sample_color_4  = texture(screen_texture, sample_point_4  * uv_scale);
    vec4 sample_color_5  = texture(screen_texture, sample_point_5  * uv_scale);
    vec4 sample_color_6  = texture(screen_texture, sample_point_6  * uv_scale);
    vec4 sample_color_7  = texture(screen_texture, sample_point_7  * uv_scale);
    vec4 sample_color_8  = texture(screen_texture, sample_point_8  * uv_scale);
    vec4 sample_color_9  = texture(screen_texture, sample_point_9  * uv_scale);
    vec4 sample_color_10 = texture(screen_texture, sample_point_10 * uv_scale);
    vec4 sample_color_11 = texture(screen_texture, sample_point_11 * uv_scale);
    vec4 sample_color_12 = texture(screen_texture, sample_point_12 * uv_scale);
    vec4 sample_color_13 = texture(screen_texture, sample_point_13 * uv_scale);
    vec4 sample_color_14 = texture(screen_texture, sample_point_14 * uv_scale);
    vec4 sample_color_15 = texture(screen_texture, sample_point_15 * uv_scale);
    vec4 sample_color_16 = texture(screen_texture, sample_point_16 * uv_scale);
    vec4 sample_color_17 = texture(screen_texture, sample_point_17 * uv_scale);
    vec4 sample_color_18 = texture(screen_texture, sample_point_18 * uv_scale);
    vec4 sample_color_19 = texture(screen_texture, sample_point_19 * uv_scale);
    vec4 sample_color_20 = texture(screen_texture, sample_point_20 * uv_scale);
    vec4 sample_color_21 = texture(screen_texture, sample_point_21 * uv_scale);
    vec4 sample_color_22 = texture(screen_texture, sample_point_22 * uv_scale);
    vec4 sample_color_23 = texture(screen_texture, sample_point_23 * uv_scale);
    vec4 sample_color_24 = texture(screen_texture, sample_point_24 * uv_scale);
    vec4 sample_color_25 = texture(screen_texture, sample_point_25 * uv_scale);
    vec4 sample_color_26 = texture(screen_texture, sample_point_26 * uv_scale);
    vec4 sample_color_27 = texture(screen_texture, sample_point_27 * uv_scale);
    vec4 sample_color_28 = texture(screen_texture, sample_point_28 * uv_scale);
    vec4 sample_color_29 = texture(screen_texture, sample_point_29 * uv_scale);
    vec4 sample_color_30 = texture(screen_texture, sample_point_30 * uv_scale);
    vec4 sample_color_31 = texture(screen_texture, sample_point_31 * uv_scale);
    vec4 sample_color_32 = texture(screen_texture, sample_point_32 * uv_scale);
    vec4 sample_color_33 = texture(screen_texture, sample_point_33 * uv_scale);
    vec4 sample_color_34 = texture(screen_texture, sample_point_34 * uv_scale);
    vec4 sample_color_35 = texture(screen_texture, sample_point_35 * uv_scale);
    vec4 sample_color_36 = texture(screen_texture, sample_point_36 * uv_scale);
    vec4 sample_color_37 = texture(screen_texture, sample_point_37 * uv_scale);
    vec4 sample_color_38 = texture(screen_texture, sample_point_38 * uv_scale);
    vec4 sample_color_39 = texture(screen_texture, sample_point_39 * uv_scale);
    vec4 sample_color_40 = texture(screen_texture, sample_point_40 * uv_scale);
    vec4 sample_color_41 = texture(screen_texture, sample_point_41 * uv_scale);
    vec4 sample_color_42 = texture(screen_texture, sample_point_42 * uv_scale);
    vec4 sample_color_43 = texture(screen_texture, sample_point_43 * uv_scale);
    vec4 sample_color_44 = texture(screen_texture, sample_point_44 * uv_scale);
    vec4 sample_color_45 = texture(screen_texture, sample_point_45 * uv_scale);
    vec4 sample_color_46 = texture(screen_texture, sample_point_46 * uv_scale);
    vec4 sample_color_47 = texture(screen_texture, sample_point_47 * uv_scale);
    vec4 sample_color_48 = texture(screen_texture, sample_point_48 * uv_scale);
    vec4 sample_color_49 = texture(screen_texture, sample_point_49 * uv_scale);
    // 计算总和
    vec4 total_color
        = sample_color_1 
        + sample_color_2 
        + sample_color_3 
        + sample_color_4 
        + sample_color_5 
        + sample_color_6 
        + sample_color_7 
        + sample_color_8 
        + sample_color_9 
        + sample_color_10
        + sample_color_11
        + sample_color_12
        + sample_color_13
        + sample_color_14
        + sample_color_15
        + sample_color_16
        + sample_color_17
        + sample_color_18
        + sample_color_19
        + sample_color_20
        + sample_color_21
        + sample_color_22
        + sample_color_23
        + sample_color_24
        + sample_color_25
        + sample_color_26
        + sample_color_27
        + sample_color_28
        + sample_color_29
        + sample_color_30
        + sample_color_31
        + sample_color_32
        + sample_color_33
        + sample_color_34
        + sample_color_35
        + sample_color_36
        + sample_color_37
        + sample_color_38
        + sample_color_39
        + sample_color_40
        + sample_color_41
        + sample_color_42
        + sample_color_43
        + sample_color_44
        + sample_color_45
        + sample_color_46
        + sample_color_47
        + sample_color_48
        + sample_color_49;
    return total_color / 49.0f; // 取平均值
}

// 主函数

layout(location = 0) in vec4 sxy;
// layout(location = 1) in vec4 pos;
layout(location = 2) in vec2 uv;
layout(location = 3) in vec4 col;

layout(location = 0) out vec4 col_out;

void main()
{
    vec2 xy = uv * screen_texture_size.xy;  // 屏幕上真实位置
    if (xy.x < viewport.x || xy.x > viewport.z || xy.y < viewport.y || xy.y > viewport.w)
    {
        discard; // 抛弃不需要的像素，防止意外覆盖画面
    }

    col_out = BoxBlur3x3(uv, radiu);
}