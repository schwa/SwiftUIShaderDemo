import SwiftUI
import simd

struct ContentView: View {

    let function = ShaderLibrary.myShader
    //    let function = ShaderLibrary.gameOfLife

    @State
    var start = Date.now

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = Float(timeline.date.timeIntervalSince(start)) * 20
            //let t = now.remainder(dividingBy: 5) * 20

            VStack {
                HStack {
                    Color.black
                        .layerEffect(shader(time), maxSampleOffset: .zero)
                        .frame(width: 256, height: 256)

                    Image(systemName: "iphone.gen1.radiowaves.left.and.right").font(.title).scaleEffect(CGSize(width: 6, height: 6))
                        .layerEffect(shader(time), maxSampleOffset: .zero)
                        .frame(width: 256, height: 256)
                }
                Text("\(time)")
            }
        }
    }

    func shader(_ time: Float) -> Shader {
        return Shader(function: function, arguments: [.float2(256, 256), .float(time)])
    }
}

#Preview {
    ContentView()
}
