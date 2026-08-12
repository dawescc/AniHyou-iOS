// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct SaveReviewMutation: GraphQLMutation {
  public static let operationName: String = "SaveReview"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation SaveReview($id: Int, $mediaId: Int!, $body: String!, $summary: String!, $score: Int!, $private: Boolean) { SaveReview( id: $id mediaId: $mediaId body: $body summary: $summary score: $score private: $private ) { __typename id summary body(asHtml: false) score private } }"#
    ))

  public var id: GraphQLNullable<Int32>
  public var mediaId: Int32
  public var body: String
  public var summary: String
  public var score: Int32
  public var `private`: GraphQLNullable<Bool>

  public init(
    id: GraphQLNullable<Int32>,
    mediaId: Int32,
    body: String,
    summary: String,
    score: Int32,
    `private`: GraphQLNullable<Bool>
  ) {
    self.id = id
    self.mediaId = mediaId
    self.body = body
    self.summary = summary
    self.score = score
    self.`private` = `private`
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "id": id,
    "mediaId": mediaId,
    "body": body,
    "summary": summary,
    "score": score,
    "private": `private`
  ] }

  nonisolated public struct Data: AniListAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.Mutation }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("SaveReview", SaveReview?.self, arguments: [
        "id": .variable("id"),
        "mediaId": .variable("mediaId"),
        "body": .variable("body"),
        "summary": .variable("summary"),
        "score": .variable("score"),
        "private": .variable("private")
      ]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      SaveReviewMutation.Data.self
    ] }

    /// Create or update a review
    public var saveReview: SaveReview? { __data["SaveReview"] }

    /// SaveReview
    ///
    /// Parent Type: `Review`
    nonisolated public struct SaveReview: AniListAPI.SelectionSet {
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
        SaveReviewMutation.Data.SaveReview.self
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
