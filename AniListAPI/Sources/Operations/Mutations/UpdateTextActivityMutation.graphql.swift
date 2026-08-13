// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct UpdateTextActivityMutation: GraphQLMutation {
  public static let operationName: String = "UpdateTextActivity"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation UpdateTextActivity($id: Int, $text: String) { SaveTextActivity(id: $id, text: $text) { __typename ... on TextActivity { ...TextActivityFragment replies { __typename ...ActivityReplyFragment } } } }"#,
      fragments: [ActivityReplyFragment.self, TextActivityFragment.self]
    ))

  public var id: GraphQLNullable<Int32>
  public var text: GraphQLNullable<String>

  public init(
    id: GraphQLNullable<Int32>,
    text: GraphQLNullable<String>
  ) {
    self.id = id
    self.text = text
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "id": id,
    "text": text
  ] }

  nonisolated public struct Data: AniListAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.Mutation }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("SaveTextActivity", SaveTextActivity?.self, arguments: [
        "id": .variable("id"),
        "text": .variable("text")
      ]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      UpdateTextActivityMutation.Data.self
    ] }

    /// Create or update text activity for the currently authenticated user
    public var saveTextActivity: SaveTextActivity? { __data["SaveTextActivity"] }

    /// SaveTextActivity
    ///
    /// Parent Type: `TextActivity`
    nonisolated public struct SaveTextActivity: AniListAPI.SelectionSet, Identifiable {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.TextActivity }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("replies", [Reply?]?.self),
        .fragment(TextActivityFragment.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        UpdateTextActivityMutation.Data.SaveTextActivity.self,
        TextActivityFragment.self
      ] }

      /// The written replies to the activity
      public var replies: [Reply?]? { __data["replies"] }
      /// The id of the activity
      public var id: Int { __data["id"] }
      /// The time the activity was created at
      public var createdAt: Int { __data["createdAt"] }
      /// If the currently authenticated user liked the activity
      public var isLiked: Bool? { __data["isLiked"] }
      /// The amount of likes the activity has
      public var likeCount: Int { __data["likeCount"] }
      /// The number of activity replies
      public var replyCount: Int { __data["replyCount"] }
      /// If the activity is locked and can receive replies
      public var isLocked: Bool? { __data["isLocked"] }
      /// The status text (Markdown)
      public var text: String? { __data["text"] }
      /// The user id of the activity's creator
      public var userId: Int? { __data["userId"] }
      /// The user who created the activity
      public var user: User? { __data["user"] }

      public struct Fragments: FragmentContainer {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        public var textActivityFragment: TextActivityFragment { _toFragment() }
      }

      /// SaveTextActivity.Reply
      ///
      /// Parent Type: `ActivityReply`
      nonisolated public struct Reply: AniListAPI.SelectionSet, Identifiable {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.ActivityReply }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(ActivityReplyFragment.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          UpdateTextActivityMutation.Data.SaveTextActivity.Reply.self,
          ActivityReplyFragment.self
        ] }

        /// The id of the reply
        public var id: Int { __data["id"] }
        /// The id of the parent activity
        public var activityId: Int? { __data["activityId"] }
        /// The time the reply was created at
        public var createdAt: Int { __data["createdAt"] }
        /// If the currently authenticated user liked the reply
        public var isLiked: Bool? { __data["isLiked"] }
        /// The amount of likes the reply has
        public var likeCount: Int { __data["likeCount"] }
        /// The reply text
        public var text: String? { __data["text"] }
        /// The id of the replies creator
        public var userId: Int? { __data["userId"] }
        /// The user who created reply
        public var user: User? { __data["user"] }

        public struct Fragments: FragmentContainer {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          public var activityReplyFragment: ActivityReplyFragment { _toFragment() }
        }

        public typealias User = ActivityReplyFragment.User
      }

      public typealias User = TextActivityFragment.User
    }
  }
}
