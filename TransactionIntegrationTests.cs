using Xunit;

public class TransactionIntegrationTests
{
    [Fact]
    public void Category_ShouldRespectItsPurpose()
    {
        var category = new Category { Name = "Aluguel", Purpose = CategoryPurpose.Expense };
        var transaction = new Transaction { Type = TransactionType.Income, Category = category };

        var ex = Assert.Throws<BusinessRuleException>(() => TransactionService.Validate(transaction));
        Assert.Equal("Categoria inválida para este tipo de transação", ex.Message);
    }
}
