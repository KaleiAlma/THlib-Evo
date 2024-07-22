//======================================
//code by Xiliusha(ETC)
//powered by OLC
//======================================

texture2D ScreenTexture:POSTEFFECTTEXTURE;
sampler2D ScreenTextureSampler = sampler_state {
    texture = <ScreenTexture>;
    AddressU  = BORDER;
    AddressV = BORDER;
    Filter = MIN_MAG_LINEAR_MIP_POINT;
};

float4 screen : SCREENSIZE;

//��ֵ�ж���ȡֵ0~1��Խ����԰�ɫ����Խ�����У�ԽС��Խ���У�Ϊ0ʱȫ�����ǲ�͸���ģ�Ϊ1ʱֻ�д���������ǲ�͸����
float threshold < string binding = "threshold"; > = 1.0;
//����ĻҶ�ͼ
texture2D Texture2 < string binding = "tex"; >;
sampler2D ScreenTextureSampler2 = sampler_state {
    texture = <Texture2>;
    AddressU = BORDER;
    AddressV = BORDER;
    Filter = MIN_MAG_LINEAR_MIP_POINT;
};

float4 PS_MainPass(float4 position:POSITION, float2 uv:TEXCOORD0):COLOR
{
    float4 texColor = tex2D(ScreenTextureSampler, uv);
    float4 texColor2 = tex2D(ScreenTextureSampler2, uv);
    float door = clamp(threshold, 0.0, 1.0);
    
    float mix = (texColor2.r + texColor2.g + texColor2.b) / 3.0;
    
    if (mix >= door) {
        texColor.a = 1.0;
    }
    else{
        texColor.a = 0.0;
    }
    
    return texColor;
}

technique Main
{
    pass MainPass
    {
        PixelShader = compile ps_3_0 PS_MainPass();
    }
}
