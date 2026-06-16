<?php
class DatabaseHandler
{
    private $dataSource = "mysql:host=localhost;dbname=stemwijzer;";
    private $username = "root";
    private $password = "";

    private function Connect()
    {
        $pdo = new PDO($this->dataSource, $this->username, $this->password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $pdo;
    }

    public function SelectElections()
    {
        try
        {
            $pdo = $this->Connect();
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
            $pdo = $this->Connect();
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
            $pdo = $this->Connect();
            $statement = $pdo->prepare(
                "SELECT q.id, q.question, q.weight
                 FROM questions q
                 JOIN questionnaire_questions qq ON q.id = qq.question_id
                 JOIN questionnaires qn ON qq.questionnaire_id = qn.id
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
            $pdo = $this->Connect();
            $statement = $pdo->prepare(
                "SELECT p.id AS party_id, p.name AS party_name, p.color_hex,
                        pa.question_id, pa.answer, q.weight
                 FROM party_answers pa
                 JOIN parties p ON pa.party_id = p.id
                 JOIN questions q ON pa.question_id = q.id
                 JOIN questionnaire_questions qq ON q.id = qq.question_id
                 JOIN questionnaires qn ON qq.questionnaire_id = qn.id
                 WHERE qn.election_id = :electionId");
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
            $pdo = $this->Connect();
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
            $pdo = $this->Connect();
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

    public function SelectDashboardResultsByUser($userId)
    {
        try
        {
            $pdo = $this->Connect();
            $statement = $pdo->prepare(
                "SELECT e.id AS election_id, e.name AS election_name, e.date AS election_date,
                        p.id AS party_id, p.name AS party_name, p.color_hex,
                        q.id AS question_id, q.weight,
                        ua.answer AS user_answer, pa.answer AS party_answer
                 FROM user_answers ua
                 JOIN questions q ON ua.question_id = q.id
                 JOIN questionnaire_questions qq ON q.id = qq.question_id
                 JOIN questionnaires qn ON qq.questionnaire_id = qn.id
                 JOIN elections e ON qn.election_id = e.id
                 JOIN election_parties ep ON ep.election_id = e.id
                 JOIN parties p ON ep.party_id = p.id
                 JOIN party_answers pa ON pa.party_id = p.id AND pa.question_id = q.id
                 WHERE ua.user_id = :userId
                 ORDER BY e.date DESC, ep.position ASC, p.name ASC"
            );
            $statement->bindParam(':userId', $userId, PDO::PARAM_INT);
            $statement->execute();
            $rows = $statement->fetchAll(PDO::FETCH_ASSOC);

            $results = [];
            foreach ($rows as $row)
            {
                $electionId = (int)$row["election_id"];
                $partyId = (int)$row["party_id"];
                $weight = (int)$row["weight"];
                $diff = abs((int)$row["user_answer"] - (int)$row["party_answer"]);
                $match = (2 - $diff) * $weight;

                if (!isset($results[$electionId]))
                {
                    $results[$electionId] = [
                        "election_name" => $row["election_name"],
                        "date" => $row["election_date"],
                        "matches" => []
                    ];
                }

                if (!isset($results[$electionId]["matches"][$partyId]))
                {
                    $results[$electionId]["matches"][$partyId] = [
                        "name"      => $row["party_name"],
                        "color_hex" => $row["color_hex"],
                        "score"     => 0,
                        "max_score" => 0
                    ];
                }

                $results[$electionId]["matches"][$partyId]["score"] += $match;
                $results[$electionId]["matches"][$partyId]["max_score"] += $weight * 2;
            }

            foreach ($results as &$result)
            {
                foreach ($result["matches"] as &$match)
                {
                    $match["score"] = $match["max_score"] > 0
                        ? (int)round(($match["score"] / $match["max_score"]) * 100)
                        : 0;
                    unset($match["max_score"]);
                }
                unset($match);

                usort($result["matches"], fn($a, $b) => $b["score"] <=> $a["score"]);
                $result["matches"] = array_slice($result["matches"], 0, 3);
            }
            unset($result);

            return array_values($results);
        }
        catch (PDOException $e)
        {
            return false;
        }
    }

    public function SaveUserAnswers($userId, $answers)
    {
        try
        {
            $pdo = $this->Connect();
            $statement = $pdo->prepare(
                "INSERT INTO user_answers (user_id, question_id, answer)
                 VALUES (:userId, :questionId, :answer)
                 ON DUPLICATE KEY UPDATE answer = VALUES(answer)"
            );

            foreach ($answers as $answer)
            {
                if (!isset($answer["question_id"], $answer["answer"]))
                {
                    continue;
                }

                $questionId = (int)$answer["question_id"];
                $answerValue = (int)$answer["answer"];

                $statement->bindParam(':userId', $userId, PDO::PARAM_INT);
                $statement->bindParam(':questionId', $questionId, PDO::PARAM_INT);
                $statement->bindParam(':answer', $answerValue, PDO::PARAM_INT);
                $statement->execute();
            }

            return true;
        }
        catch (PDOException $e)
        {
            return false;
        }
    }
}
?>
