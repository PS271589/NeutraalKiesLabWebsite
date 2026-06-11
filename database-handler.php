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

    public function SelectQuestionsByElection($electionId)
    {
        try
        {
            $pdo = new PDO($this->dataSource, $this->username, $this->password);
            $statement = $pdo->prepare(
                "SELECT q.id, q.question, q.weight
                 FROM questions q
                 JOIN questionnaires qn ON q.questionnaire_id = qn.id
                 WHERE qn.election_id = :electionId
                 ORDER BY q.id ASC"
            );
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

    public function SelectPartyAnswersByElection($electionId)
    {
        try
        {
            $pdo = new PDO($this->dataSource, $this->username, $this->password);
            $statement = $pdo->prepare(
                "SELECT p.id AS party_id, p.name AS party_name,
                        pa.question_id, pa.answer, q.weight
                 FROM party_answers pa
                 JOIN parties p ON pa.party_id = p.id
                 JOIN questions q ON pa.question_id = q.id
                 JOIN questionnaires qn ON q.questionnaire_id = qn.id
                 WHERE qn.election_id = :electionId"
            );
            $statement->bindParam(':electionId', $electionId, PDO::PARAM_INT);
            $statement->execute();
            return $statement->fetchAll(PDO::FETCH_ASSOC);
        }
        catch (PDOException $e)
        {
            return false;
        }
    }

    public function CreateUser($name, $email, $password, $role = "user")
    {
        try
        {
            $pdo = new PDO($this->dataSource, $this->username, $this->password);
            $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
            $statement = $pdo->prepare("INSERT INTO users (name, email, password, role) VALUES (:name, :email, :password, :role)");
            $statement->bindParam(':name', $name);
            $statement->bindParam(':email', $email);
            $statement->bindParam(':password', $hashedPassword);
            $statement->bindParam(':role', $role);
            return $statement->execute();
        }
        catch (PDOException $e)
        {
            return false;
        }
    }

    public function SelectUserByEmail($email)
    {
        try
        {
            $pdo = new PDO($this->dataSource, $this->username, $this->password);
            $statement = $pdo->prepare("SELECT * FROM users WHERE email = :email");
            $statement->bindParam(':email', $email);
            $statement->execute();
            return $statement->fetch(PDO::FETCH_ASSOC);
        }
        catch (PDOException $e)
        {
            return false;
        }
    }
}
?>