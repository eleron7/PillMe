import SwiftUI
 
struct SearchBarView: View {
    
    @State var searchType: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 30))
                
                //검색창은 searchType에 따라 다른 PlaceHolder 출력
                if (searchType == "friend")
                {
                    TextField("ID를 검색하여 친구를 추가하세요", text: $text)
                        .keyboardType(.default)
                        .foregroundColor(.primary)
                        .font(.system(size: 20))
                }
                else
                {
                    TextField("알고싶은 약 이름을 검색하세요", text: $text)
                        .keyboardType(.default)
                        .foregroundColor(.primary)
                        .font(.system(size: 20))
                }
                
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                } else {
                    EmptyView()
                }
            }
            .frame(height:50)
            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(30.0)
        }
        .padding(.horizontal)
    }
}
