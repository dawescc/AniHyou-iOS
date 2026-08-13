// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct UpdateActivityReplyMutation: GraphQLMutation {
  public static let operationName: String = "UpdateActivityReply"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation UpdateActivityReply($activityId: Int, $id: Int, $text: String) { SaveActivityReply(activityId: $activityId, id: $id, text: $text) { __typename ...ActivityReplyFragment } }"#,
      fragments: [ActivityReplyFragment.self]
    ))

  public var activityId: GraphQLNullable<Int32>
  public var id: GraphQLNullable<Int32>
  public var text: GraphQLNullable<String>

  public init(
    activityId: GraphQLNullable<Int32>,
    id: GraphQLNullable<Int32>,
    text: GraphQLNullable<String>
  ) {
    self.activityId = activityId
    self.id = id
    self.text = text
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "activityId": activityId,
    "id": id,
    "text": text
  ] }

  nonisolated public struct Data: AniListAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.Mutation }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("SaveActivityReply", SaveActivityReply?.self, arguments: [
        "activityId": .variable("activityId"),
        "id": .variable("id"),
        "text": .variable("text")
      ]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      UpdateActivityReplyMutation.Data.self
    ] }

    /// Create or update an activity reply
    public var saveActivityReply: SaveActivityReply? { __data["SaveActivityReply"] }

    /// SaveActivityReply
    ///
    /// Parent Type: `ActivityReply`
    nonisolated public struct SaveActivityReply: AniListAPI.SelectionSet, Identifiable {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.ActivityReply }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(ActivityReplyFragment.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        UpdateActivityReplyMutation.Data.SaveActivityReply.self,
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
  }
}
