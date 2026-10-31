# CLAUDE.md

Guidance for Claude Code when working in this repository.

## CapCut integration (MCP)

This repo ships its own MCP server, registered for Claude Code in `.mcp.json` as `capcut-api`.
Claude Code starts it via `scripts/run_mcp_server.sh` (approve it the first time you run
`claude` here). The server exposes exactly two tools:

- `search_tools(query)` - find editing tools and read their JSON Schema before calling them.
- `invoke_tool(name, arguments)` - run one tool by exact name.

Typical editing flow:

1. `invoke_tool("create_draft", {"width": 1080, "height": 1920})` -> keep the `draft_id`.
2. `add_video` / `add_audio` / `add_image` / `add_text` / `add_subtitle` / `add_effect` /
   `add_sticker` / `add_video_keyframe`, passing the same `draft_id` each time.
3. `query_script` to inspect the timeline if needed.
4. `save_draft` -> writes the draft into CapCut's drafts folder (`local_path` in the result),
   where it opens in the CapCut app.
5. Optional: `export_video` (poll `query_export_status`), `export_subtitles`, `export_draft`.

Never guess enum strings (transitions, masks, fonts, animations, effects): call
`list_option_values` with the category first. Run `export_preflight` before `export_video` to
see which backend works on this machine (`capcut` needs a macOS GUI session; `ffmpeg` is headless).

## Development

- Python 3.10+. Install: `pip install -r requirements.txt -r requirements-mcp.txt`
  (ffmpeg/ffprobe must be on PATH for media probing and the ffmpeg export backend).
- Tests: `pytest` (GUI tests are excluded by default).
- New capabilities go in `tool_registry.TOOLS` plus a branch in `tool_registry.execute_tool`;
  never register them as separate MCP tools (see the docstring in `mcp_server.py`;
  `tests/test_gateway_surface.py` enforces it).
