import { readFile } from "node:fs/promises"
import { basename, resolve } from "node:path"
import { tool } from "@opencode-ai/plugin"
import { formatFromBytes, toMarkdownBytes } from "@firecrawl/anydoc"
import {
  classifyPdfAsync,
  extractPagesMarkdownAsync,
  processPdfWithOcr,
} from "@firecrawl/pdf-inspector"

const PDF_FORMAT = "pdf"

export default tool({
  description:
    "Convert supported documents to Markdown or inspect a PDF. Use convert for document contents, inspect for PDF type and OCR-page information, or ocr for scanned and mixed PDFs. Uses pdf-inspector for PDF requests and AnyDoc for non-PDF documents.",
  args: {
    path: tool.schema
      .string()
      .describe("Path to the document, relative to the current project or absolute"),
    operation: tool.schema
      .enum(["convert", "inspect", "ocr"])
      .default("convert")
      .describe("Convert the document, inspect PDF classification, or run OCR"),
  },
  async execute(args, context) {
    const path = resolve(context.directory, args.path)
    const bytes = await readFile(path)
    const filename = basename(path)
    const format = formatFromBytes(bytes)

    if (format === PDF_FORMAT) {
      const classification = await classifyPdfAsync(bytes)

      if (args.operation === "inspect") {
        const pages = classification.pagesNeedingOcr.length
          ? `\nPages needing OCR: ${classification.pagesNeedingOcr.map((page) => page + 1).join(", ")}.`
          : ""
        return [
          `PDF: ${filename}`,
          `Type: ${classification.pdfType}`,
          `Pages: ${classification.pageCount}`,
          `Confidence: ${classification.confidence.toFixed(2)}.${pages}`,
        ].join("\n")
      }

      if (args.operation === "ocr") {
        const result = await processPdfWithOcr(bytes)
        return result.markdown
      }

      if (classification.pdfType !== "TextBased") {
        const pages = classification.pagesNeedingOcr.length
          ? ` Pages needing OCR: ${classification.pagesNeedingOcr.map((page) => page + 1).join(", ")}.`
          : ""
        return [
          `PDF classification: ${classification.pdfType}.`,
          `Confidence: ${classification.confidence.toFixed(2)}.${pages}`,
          "Native PDF text extraction was not selected because this PDF contains scanned, image-only, or mixed pages.",
          "Use pdf-inspector's OCR-capable path or a hosted OCR service when OCR is appropriate.",
        ].join("\n")
      }

      const result = await extractPagesMarkdownAsync(bytes)
      return result.pages.map((page) => page.markdown).join("\n\n")
    }

    if (!format) {
      throw new Error(
        `Unsupported or unrecognized document format: ${filename}. Supported formats include DOCX, PPTX, XLSX, ODT, RTF, EPUB, CSV, and PDF.`,
      )
    }

    const markdown = await toMarkdownBytes(bytes, format)
    return markdown
  },
})
