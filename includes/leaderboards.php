<?php

require('../totallynotdbcon/nopenotdbcon.php');

//Submit to leaderboards
if (isset($_POST["points"])) {

	$name = $_POST["name"];
	$category = $_POST["playedCategory"];
	$points = $_POST["points"];

	$query = "
	SELECT
	categories.id AS categoryID
	FROM categories
	WHERE categories.category = :category;
	";

	//Setja inn category
	$query_params = array(
		':category' => $category
		);

	//Keyra
	try
	{
		$stmt = $pdo->prepare($query);
		$result = $stmt->execute($query_params);
	}
	catch(PDOException $ex)
	{
		die("Failed to run query: " . $ex->getMessage());
	}

	$category = $stmt->fetch(); //Sækja

	$query = "
	INSERT INTO leaderboards (`name`, `category`, `points`)
	VALUES
	(:name,:category,:points)
	";

	//Setja inn breytur
	$query_params = array(
		':name' => $name,
		':category' => $category["categoryID"],
		':points' => $points
		);

	//Keyra
	try
	{
		$stmt = $pdo->prepare($query);
		$result = $stmt->execute($query_params);
	}
	catch(PDOException $ex)
	{
		die("Failed to run query: " . $ex->getMessage());
	}

	echo "success";
}

//Fetch leaderboards
else if (isset($_POST["category"])) {

	$category = $_POST["category"]; //Category

	//Fyrsta query: Sækja spurninguna, svarið og meta-data
	//Seinna query: Sækja valkostina og meta-data
	$query = "
	SELECT
	leaderboards.name AS name,
	categories.category AS category,
	leaderboards.points AS points,
	leaderboards.date AS date
	FROM leaderboards
	JOIN categories ON (leaderboards.category=categories.id)
	WHERE categories.category = :category
	ORDER BY leaderboards.points DESC
	LIMIT 10;
	";

	//Setja inn category
	$query_params = array(
		':category' => $category
		);

	//Keyra
	try
	{
		$stmt = $pdo->prepare($query);
		$result = $stmt->execute($query_params);
	}
	catch(PDOException $ex)
	{
		die("Failed to run query: " . $ex->getMessage());
	}

	$leaderboards = $stmt->fetchAll(); //Sækja


	$leaderboards["result"] = "success"; //Láta JS vita að ekkert fór útskeðis

	echo json_encode($leaderboards); //Echo

}

else{
	echo "AJAX is fucked up";
}