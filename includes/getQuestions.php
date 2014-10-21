<?php

require('../totallynotdbcon/nopenotdbcon.php');

if (isset($_POST["category"])) {

	$category = $_POST["category"]; //Category

	//Fyrsta query: Sækja spurninguna, svarið og meta-data
	//Seinna query: Sækja valkostina og meta-data
	$query = "
	SELECT
	questions.question AS question,
	choices.choice AS answer,
	types.typeName AS type,
	universes.universeName AS universe,
	genders.gender AS gender,
	questions.image AS image
	FROM questions
	JOIN categories ON (questions.category=categories.id)
	JOIN choices ON (questions.answer=choices.id)
	JOIN types ON (questions.type=types.id)
	JOIN universes ON (questions.universe=universes.id)
	JOIN genders ON (questions.gender=genders.id)
	WHERE categories.category = :category
	LIMIT 15;

	SELECT
	choices.choice AS choice,
	types.typeName AS type,
	universes.universeName AS universe,
	genders.gender AS gender
	FROM choices
	JOIN categories ON (choices.category=categories.id)
	JOIN types ON (choices.type=types.id)
	JOIN universes ON (choices.universe=universes.id)
	JOIN genders ON (choices.gender=genders.id);
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

	$questions = $stmt->fetchAll(); //Sækja

	$stmt->nextRowset(); //Næsta query
	$choices = $stmt->fetchAll(); //Sækja

	shuffle($choices); //Randomize the order of the array


	$counter = 0; //Svo að ég fæ rétt magn af svörum

	for ($i=0; $i < count($questions); $i++) {

		//Bæta við choices = array() fyrir hverja spurningu
		$questions[$i]["choices"] = array();

		for ($j=0; $j < count($choices); $j++) {

			if ($questions[$i]["type"] == "truefalse" && count($questions[$i]["choices"]) != 2) {
				array_push($questions[$i]["choices"], "True");
				array_push($questions[$i]["choices"], "False");
			}

			//Ef valkosturinn er með sama type, alheim og er ekki svarið
			else if ($questions[$i]["type"] == $choices[$j]["type"] && $questions[$i]["universe"] == $choices[$j]["universe"] && $questions[$i]["answer"] != $choices[$j]["choice"]) {

				//Ef það er gender
				if ($questions[$i]["gender"] != null && $counter != 3) {

					if ($questions[$i]["gender"] == $choices[$j]["gender"]) {
						array_push($questions[$i]["choices"], $choices[$j]["choice"]);
						$counter++;
					}
					
				} //Annars
				else if($counter != 3){
					array_push($questions[$i]["choices"], $choices[$j]["choice"]);
					$counter++;
				}

				else{ //Ef ég er kominn með valkostina, bæta við rétta svarinu og reset counter fyrir næstu spurningu
					array_push($questions[$i]["choices"], $questions[$i]["answer"]);
					$counter = 0;
					break;
				}
			}
		}

		if ($questions[$i]["type"] != "truefalse") {
			shuffle($questions[$i]["choices"]); //Randomize the order of the choices
		}
		
	}

	shuffle($questions);

	$questions["result"] = "success"; //Láta JS vita að ekkert fór útskeðis

	echo json_encode($questions); //Echo

}

else{
	echo "AJAX is fucked up";
}