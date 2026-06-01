<?php
class DatabaseHandler
{
    private $dataSource = "mysql:host=localhost;dbname=stemwijzer;";
    private $username = "root";
    private $password = "password";

    public function SelectUsers()
    {
        try
        {
            $pdo = new PDO($this->dataSource, $this->username, $this->password);
            $statement = $pdo->prepare("SELECT * FROM users");
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