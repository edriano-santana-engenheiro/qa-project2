using Xunit;

public class PersonTests
{
    [Fact]
    public void Minor_ShouldNotAllowIncomeTransaction()
    {
        var person = new Person { Age = 16 };
        var transaction = new Transaction { Type = TransactionType.Income, Amount = 100 };

        var ex = Assert.Throws<BusinessRuleException>(() => person.AddTransaction(transaction));
        Assert.Equal("Menor de idade não pode ter receitas", ex.Message);
    }
}
