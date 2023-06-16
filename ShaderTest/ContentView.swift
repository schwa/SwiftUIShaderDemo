import SwiftUI
import simd

struct ContentView: View {

    let function = ShaderLibrary.myShader
//    let function = ShaderLibrary.gameOfLife

    var body: some View {
        VStack {
            TimelineView(.animation) { context in
                //Text("\(context.date.timeIntervalSince1970)").monospaced()
                Color.black
                .layerEffect(shader(context.date.timeIntervalSince1970), maxSampleOffset: .zero)
                .frame(width: 256, height: 256).font(.title).bold()
                Text("\(context.date.timeIntervalSince1970)").monospaced()
            }
        }
    }

    func shader(_ time: CFTimeInterval) -> Shader {
        return Shader(function: function, arguments: [.float2(256, 256), .float(time)])
    }
}

#Preview {
    ContentView()
}
