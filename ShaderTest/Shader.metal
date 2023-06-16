#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
#include <simd/simd.h>

using namespace metal;

[[ stitchable ]] half4
myShader(float2 position, SwiftUI::Layer layer, float2 size, float time) {
    
    const vector_float2 xy = position.xy / 8;
    const float x = xy.x;
    const float y = xy.y;

    const float step = time;

    const float xs = sin(step / 100.0) * 20.0;
    const float ys = cos(step / 100.0) * 20.0;
    const float scale = ((sin(step / 60.0) + 1.0) / 5.0) + 0.2;
    const float r = sin((x + xs) * scale) + cos((y + xs) * scale);
    const float g = sin((x + xs) * scale) + cos((y + ys) * scale);
    const float b = sin((x + ys) * scale) + cos((y + ys) * scale);

    half4 value = layer.sample(position);

    return half4(r, g, b, value.a);
}

// MARK: -

bool rules(uint count, bool alive) {
    if (alive == true && (count == 2 || count == 3)) {
        return true;
    }
    else if (alive == false && count == 3) {
        return true;
    }
    else if (alive == true) {
        return false;
    }
    else {
        return false;
    }
}

[[ stitchable ]] half4
gameOfLife(float2 position, SwiftUI::Layer layer, float2 size, float time) {
    const float2 offsets[] = {
        float2(-1, -1),
        float2( 0, -1),
        float2(+1, -1),
        float2(-1,  0),
        float2(+1,  0),
        float2(-1, +1),
        float2( 0, +1),
        float2(+1, +1),
    };
    uint count = 0;
    for (int N = 0; N != 8; ++N) {
        const float2 offset = position + offsets[N] / size;
        half4 value = layer.sample(offset);
        count += value.a != 0;
    }
    bool alive = layer.sample(position).a != 0;
    bool stillAlive = rules(count, alive);
    return stillAlive ? half4(0, 0, 0, 1) : half4(0, 0, 0, 0);
}
