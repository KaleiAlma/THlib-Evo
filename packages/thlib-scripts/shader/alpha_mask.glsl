#version 410 core
// --------------------------------------------------------------------------------
// 遮罩功能
// 根据灰度图生成 alpha 通道
// 璀境石
// --------------------------------------------------------------------------------

// 引擎设置的参数，不可修改

uniform sampler2D screen_texture;

uniform engine_data
{
    vec4 screen_texture_size; // 纹理大小
    vec4 viewport;            // 视口
};


// 用户传递的浮点参数
// 由多个 float4 组成，且 float4 是最小单元，最多可传递 8 个 float4

// cbuffer user_data : register(b0)
// {
//     float4   user_data_0;
// };

// 用户传递的纹理和采样器参数，可用槽位 0 到 3

uniform sampler2D mask_texture;


// 常量

const float _1_3 = 1.0f / 3.0f;

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

    vec4 texture_color = texture(screen_texture, uv);
    vec4 mask_color = texture(mask_texture, uv);
    texture_color *= ((mask_color.r + mask_color.g + mask_color.b) * _1_3);

    col_out = texture_color;
}

// lua 侧调用（仅用于说明参数如何传递，并非可正常运行的代码）
/*

lstg.CreateRenderTarget("RenderTarget")
lstg.CreateRenderTarget("Mask")

lstg.PushRenderTarget("RenderTarget")
...
lstg.PopRenderTarget()

lstg.PushRenderTarget("Mask")
...
lstg.PopRenderTarget()

lstg.PostEffect(
    -- 着色器资源名称
    "texture_mask",
    -- 屏幕渲染目标，采样器类型
    "RenderTarget", 6,
    -- 混合模式
    "mul+alpha",
    -- 浮点参数
    {},
    -- 纹理与采样器类型参数
    {
        { "Mask", 6 },
    }
)

*/
