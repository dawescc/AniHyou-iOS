//
//  StringTests.swift
//  AniHyouTests
//
//  Created by Axel Lopez on 18/04/2024.
//

import Testing
@testable import AniHyou

// swiftlint:disable all
struct StringTests {

    @Test func testHtmlStrip() async throws {
        let html = "<p>This is a test</p>"
        let stripped = html.htmlStripped
        #expect(stripped == "This is a test")
    }

    @Test @MainActor func testAniListHtmlFormatting() async throws {
        let html = "<p align=\"center\">\n\n# ⚡ SYSTEM.EXE — INITIALIZING...\n\nSTATUS: ONLINE ?\n\n---\n\n### ? SYSTEM INFO\n\nOS       : HUMAN\nUPTIME   : 24 YEARS\nSTATUS   : WATCHING ANIME\nENERGY   : ▓▓░░░░░░░░ LOW\nLOCATION : COUCH.exe\n\n---\n\n### ? GENRE PROTOCOL\n\n`SHONEN` · `COMEDY` · `ISEKAI` · `SEASONAL_WATCHER`\n\n---\n\n### ? CORE MEMORY [FAVORITES]\n\n> **One Piece** — the endless voyage\n> **Bleach** — style unmatched\n> **Hunter x Hunter** — peak storytelling\n> **Dragon Ball** — where it all began\n\n---\n\n### ? LOGS\n\n> rewatch_anime() → FALSE\n> reason: \"too many stories waiting to be discovered\"\n\n---\n\n### ? STAT SHEET\n\nHP     ▓▓▓▓▓▓▓▓▓▓ 100%\nSANITY ▓▓▓▓░░░░░░  42%\nMONEY  ▓░░░░░░░░░   7%\nANIME  ▓▓▓▓▓▓▓▓▓▓   ∞\n\n---\n\n>> connection stable... booting waifu.dll... ?\n\n</p>"
        
        let formatted = html.formatCompatibleHtml()
        
        print(formatted)
    }
}
// swiftlint:enable all
