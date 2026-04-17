import { render, screen } from "@testing-library/react";
import TransactionForm from "../../src/components/TransactionForm";

it("deve exibir erro ao tentar cadastrar receita para menor de idade", async () => {
  render(<TransactionForm personAge={16} />);
  // simula preenchimento
  // espera mensagem de erro
  expect(await screen.findByText(/Menor de idade não pode ter receitas/)).toBeInTheDocument();
});
