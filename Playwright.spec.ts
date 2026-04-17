import { test, expect } from "@playwright/test";

test("Fluxo completo de exclusão em cascata", async ({ page }) => {
  await page.goto("/pessoas");
  await page.click("text=Adicionar Pessoa");
  await page.fill("input[name='nome']", "Maria");
  await page.click("text=Salvar");

  await page.click("text=Adicionar Transação");
  await page.fill("input[name='valor']", "100");
  await page.click("text=Salvar");

  await page.click("text=Excluir Pessoa");
  await expect(page.locator("text=Transação")).toHaveCount(0);
});
