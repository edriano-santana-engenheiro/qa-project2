import { describe, it, expect } from "vitest";
import { validateCategoryUsage } from "../../src/utils/validation";

describe("Categoria", () => {
  it("não deve permitir categoria de despesa em receita", () => {
    const result = () => validateCategoryUsage("Despesa", "Receita");
    expect(result).toThrowError("Categoria inválida para este tipo de transação");
  });
});
