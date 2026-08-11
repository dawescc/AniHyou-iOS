// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct UserMediaReviewQuery: GraphQLQuery {
  public static let operationName: String = "UserMediaReview"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query UserMediaReview($mediaId: Int, $userId: Int) { Page(page: 1, perPage: 1) { __typename reviews(mediaId: $mediaId, userId: $userId) { __typename id summary body(asHtml: false) score private } } }"#
    ))

  public var mediaId: GraphQLNullable<Int32>
  public var userId: GraphQLNullable<Int32>

  public init(
    mediaId: GraphQLNullable<Int32>,
    userId: GraphQLNullable<Int32>
  ) {
    self.mediaId = mediaId
    self.userId = userId
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "mediaId": mediaId,
    "userId": userId
  ] }

  nonisolated public struct Data: AniListAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("Page", Page?.self, arguments: [
        "page": 1,
        "perPage": 1
      ]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      UserMediaReviewQuery.Data.self
    ] }

    public var page: Page? { __data["Page"] }

    /// Page
    ///
    /// Parent Type: `Page`
    nonisolated public struct Page: AniListAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.Page }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("reviews", [Review?]?.self, arguments: [
          "mediaId": .variable("mediaId"),
          "userId": .variable("userId")
        ]),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        UserMediaReviewQuery.Data.Page.self
      ] }

      public var reviews: [Review?]? { __data["reviews"] }

      /// Page.Review
      ///
      /// Parent Type: `Review`
      nonisolated public struct Review: AniListAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.Review }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", Int.self),
          .field("summary", String?.self),
          .field("body", String?.self, arguments: ["asHtml": false]),
          .field("score", Int?.self),
          .field("private", Bool?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          UserMediaReviewQuery.Data.Page.Review.self
        ] }

        /// The id of the review
        public var id: Int { __data["id"] }
        /// A short summary of the review
        public var summary: String? { __data["summary"] }
        /// The main review body text
        public var body: String? { __data["body"] }
        /// The review score of the media
        public var score: Int? { __data["score"] }
        /// If the review is not yet publicly published and is only viewable by creator
        public var `private`: Bool? { __data["private"] }
      }
    }
  }
}
