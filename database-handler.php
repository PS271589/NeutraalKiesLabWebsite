<?php
class DatabaseHandler
{
    private $dataSource = "mysql:host=localhost;dbname=stemwijzer;";
    private $username = "root";
    private $password = "";

    public function SelectElections()
    {
        try
        {
            $pdo = new PDO($this->dataSource, $this->username, $this->password);
            $statement = $pdo->prepare("SELECT * FROM elections");
            $statement->execute();
            $rows = $statement->fetchAll(PDO::FETCH_ASSOC);
            return $rows;
        }
        catch (PDOException $e)
        {
            return false;
        }
    }

    public function SelectPartiesByElection($electionId)
    {
        try
        {
            $pdo = new PDO($this->dataSource, $this->username, $this->password);
            $statement = $pdo->prepare("SELECT p.* FROM parties p JOIN election_parties ep ON p.id = ep.party_id WHERE ep.election_id = :electionId");
            $statement->bindParam(':electionId', $electionId, PDO::PARAM_INT);
            $statement->execute();
            $rows = $statement->fetchAll(PDO::FETCH_ASSOC);
            return $rows;
        }
        catch (PDOException $e)
        {
            return false;
        }
    }
}
?>