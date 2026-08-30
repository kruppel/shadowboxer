# Document handling

- When a user asks to read, summarize, analyze, or extract information from a PDF or supported document file, use the `convert-document` tool before responding.
- Do not claim that PDF input is unsupported until `convert-document` has been tried.
- For a PDF, use `inspect` when classification or OCR-page information is needed, `convert` for text-based PDFs, and `ocr` for scanned or mixed PDFs.
- Use the converted Markdown as the source for the response. If conversion fails, report the actual error and explain the next available option.
