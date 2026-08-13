//
//  ActivityItemView.swift
//  AniHyou
//
//  Created by Axel Lopez on 17/10/2023.
//

import SwiftUI
import AniListAPI
import Textual

struct TextActivityItemView: View {
    
    let activity: TextActivityFragment
    @State private var isLiked: Bool
    @State private var likeCount: Int
    @State private var showingEditSheet = false
    let isMine: Bool
    
    init(activity: TextActivityFragment, isMine: Bool) {
        self.activity = activity
        self.isLiked = activity.isLiked == true
        self.likeCount = activity.likeCount
        self.isMine = isMine
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                NavigationLink(destination: ProfileView(userId: activity.userId ?? 0)) {
                    HStack(alignment: .center) {
                        CircleImageView(imageUrl: activity.user?.avatar?.medium, size: 24)
                        
                        Text(activity.user?.name ?? "Loading")
                            .bold()
                            .font(.subheadline)
                            .padding(.bottom, 1)
                    }
                }
                .foregroundStyle(.primary)
                Spacer()
                let createdAt = Date(timeIntervalSince1970: Double(activity.createdAt))
                Text("\(createdAt, format: .relative(presentation: .numeric))")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .padding(.bottom, 1)
                
                if isMine {
                    Menu("", systemImage: "ellipsis") {
                        Button("Edit", systemImage: "pencil") {
                            showingEditSheet = true
                        }
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            Task {
                                if let deleted = await ActivityRepository.deleteActivity(id: Int32(activity.id)) {
                                    if deleted {
                                        NotificationCenter.default.post(name: "updatedActivity", object: nil)
                                    }
                                }
                            }
                        }
                    }
                    .tint(nil)
                }
            }//:HStack
            
            InlineText(markdown: activity.text?.formatMarkdown() ?? "Loading")
            
            HStack {
                Spacer()
                NavigationLink(
                    destination: ActivityDetailsView(activityId: activity.id)
                ) {
                    Label("\(activity.replyCount)", systemImage: "bubble")
                }
                .frame(width: 62, alignment: .leading)
                Button(
                    action: {
                        Task {
                            if let likeResult = await LikeRepository.toggleLike(
                                likeableId: Int32(activity.id),
                                likeableType: .activity
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
        .sheet(isPresented: $showingEditSheet) {
            PublishActivityView(id: activity.id, text: activity.text ?? "")
        }
    }
}

/*#Preview {
    TextActivityItemView(activity: TextActivityFragment(_fieldData: nil))
}*/
