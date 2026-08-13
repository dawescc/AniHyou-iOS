//
//  ActivityReplyItemView.swift
//  AniHyou
//
//  Created by Axel Lopez on 18/10/2023.
//

import SwiftUI
import Textual
import AniListAPI

struct ActivityReplyItemView: View {
    
    let reply: ActivityReplyFragment
    @State private var isLiked: Bool
    @State private var likeCount: Int
    let isMine: Bool
    
    init(reply: ActivityReplyFragment, isMine: Bool) {
        self.reply = reply
        self.isLiked = reply.isLiked == true
        self.likeCount = reply.likeCount
        self.isMine = isMine
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                NavigationLink(destination: ProfileView(userId: reply.userId ?? 0)) {
                    HStack(alignment: .center) {
                        CircleImageView(imageUrl: reply.user?.avatar?.medium, size: 24)
                        
                        Text(reply.user?.name ?? "Loading")
                            .bold()
                            .font(.subheadline)
                            .padding(.bottom, 1)
                    }
                }
                .foregroundStyle(.primary)
                Spacer()
                let createdAt = Date(timeIntervalSince1970: Double(reply.createdAt))
                Text("\(createdAt, format: .relative(presentation: .numeric))")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .padding(.bottom, 1)
                
                if isMine {
                    Menu("", systemImage: "ellipsis") {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            Task {
                                if let deleted = await ActivityRepository.deleteActivityReply(id: Int32(reply.id)) {
                                    if deleted {
                                        NotificationCenter.default.post(name: "updatedActivityReply", object: nil)
                                    }
                                }
                            }
                        }
                        .tint(nil)
                    }
                }
            }//:HStack
            
            InlineText(markdown: reply.text?.formatMarkdown() ?? "Loading")
            
            HStack {
                Spacer()
                Button(
                    action: {
                        Task {
                            if let likeResult = await LikeRepository.toggleLike(
                                likeableId: Int32(reply.id),
                                likeableType: .activityReply
                            ) {
                                isLiked = likeResult
                                if likeResult {
                                    likeCount += 1
                                } else {
                                    likeCount -= 1
                                }
                            }
                        }
                    }
                ) {
                    Label("\(likeCount)",
                          systemImage: isLiked ? "heart.fill" : "heart"
                    )
                }
                .frame(width: 60, alignment: .leading)
            }//:HStack
            .padding(.top, 4)
        }//:VStack
        .padding(.horizontal)
        .padding(.vertical, 1)
    }
}

/*#Preview {
    ActivityReplyItemView()
}*/
