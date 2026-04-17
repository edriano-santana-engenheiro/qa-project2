using Xunit;

public class ApiEndToEndTests
{
    [Fact]
    public void DeletePerson_ShouldCascadeDeleteTransactions()
    {
        var repo = new PersonRepository();
        var person = repo.Create(new Person { Name = "João" });
        repo.AddTransaction(person.Id, new Transaction { Type = TransactionType.Expense, Amount = 50 });

        repo.Delete(person.Id);

        Assert.Empty(repo.GetTransactionsByPerson(person.Id));
    }
}
