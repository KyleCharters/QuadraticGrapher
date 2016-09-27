% The "Quadratic" Program
% First, the program calculates the following information about a quadratic equation
% - Standard Form
% - Factored Form
% - Vertex Form
% - Opening Direction
% - Horizontal Translation
% - Vertical Translation
% - Vertex x & y Locations
% - Root Locations
% - Y-Intercept Location
% - Y-Intercept Location reflected on axis of symmetry
% - Stretch Factor
% - Discriminant
% Next, the program creates a 200 x 200 graph, centered on (0, 0) and projected onto a 400p x 400p area
% Finally, it draws the graph data, as well as the
% vertex location, y-intercept, roots, slope, axis of symmetry and y-intercept reflected on axis of symmetry.
% The program also lets you save the generated graph, which creates a txt file with the information, and a picture of the graph
% REQUIED: Legend.bmp and Graph.bmp must be in the SAME FOLDER whil running
% ENTERING A TEXT FIELD REQUIRES PRESSING ENTER FOR EACH VALUE
% Made by Kyle Charters
% May 14, 2015
% Ref: MathIsFun Quadratic Equation
% Ref: YCDSB Exploring the factored form of a Parabola
% Ref: MathWarehouse Standard and Vertex form
% Ref: CompSci Forums How to read and write to a file in Turing

import GUI

var eLabel, iLabel1, iLabel2, iLabel3, iLabel4, iLabel5, iLabel6, iLabel7, iLabel8, iLabel9, iLabel10, iLabel11, iLabel12 : int % GUI Labels
var aValid, bValid, cValid : boolean := true % Validity of each input
var a : real := 1.0 % Value of a
var b : real := 0.0 % Value of b
var c : real := 0.0 % Value of c
var imaginary : boolean % Imaginary value
var discriminant, vertexX, vertexY, root1, root2, reflectionX : real % Information values

% Load graph background
Pic.ScreenLoad("Graph.bmp", 0, 0, picCopy)
var graph := Pic.New(0, 0, 399, 399)

% Load legend
Pic.ScreenLoad("Legend.bmp", 0, 0, picCopy)
var legend := Pic.New(0, 0, 49, 79)

% Calculates the y position for the given x value
function findY(x : real) : real
    result (a * x ** 2) + (b * x) + c
end findY

%Finds the graph position for a given x value
function gposX(x : real) : int
    result max(395, round(x * 2 + 600))
end gposX

%Finds the graph position for a given y value
function gposY(y : real) : int
    result round(y * 2 + 200)
end gposY

function translateToFunction(number : real) : string
    if number > 0 then
        result "+ " + realstr(number, 0)
    else
        result "- " + realstr(-number, 0)
    end if
end translateToFunction

% Graphs the data given from the array
procedure graphData(data : array 0 .. 200 of int)
    var lastX : int := -100
    var lastY : int := data(0)
    
    for i : 1 .. 200 % Iterate through provided graph array
        Draw.Line(gposX(lastX), gposY(lastY), gposX(lastX+1), gposY(data(i)), brightred) % Draw a line from last x & y position to current x & y
        
        lastX += 1 % Update last x to new value
        lastY := data(i) % Update last y to new value
    end for
end graphData


% Updates the Error message
procedure updateError
    var errorMessage : string := ""
    
    if not aValid then errorMessage += "A is invalid, " end if % Check a value validity
    if not bValid then errorMessage += "B is invalid, " end if % Check b value validity
    if not cValid then errorMessage += "C is invalid, " end if % Check c value validity
    
    % Check if any of the values are not valid
    if errorMessage not= "" then
        errorMessage += "invalid values set to 0/1."
    else
        errorMessage := "No errors."
    end if
    
    GUI.SetLabel(eLabel, errorMessage) % Update the error label
end updateError

% Update the Values
procedure updateValues
    discriminant := b ** 2 - 4 * a * c % Update discriminant
    imaginary := discriminant < 0 % Update imaginary roots values
    
    if not imaginary then
        % Update roots when not imaginary
        root1 := (-b + sqrt(discriminant)) / (2 * a)
        root2 := (-b - sqrt(discriminant)) / (2 * a)
    else
        % Update roots when imaginary
        root1 := (-b + sqrt(-discriminant)) / (2 * a)
        root2 := (-b - sqrt(-discriminant)) / (2 * a)
    end if
    
    vertexX := -b / (2 * a) % Update the vertex y position
    vertexY := c - (b ** 2) / (4 * a) % Update the vertex x position
    reflectionX := vertexX * 2 % Update the reflection position
end updateValues

% Updates the Graph
procedure updateGraph
    % Update background images
    GUI.SetBackgroundColor(gray)
    Pic.Draw(graph, 400, 0, picMerge)
    Pic.Draw(legend, 341, 29, picMerge)
    
    % Calculate data
    var data : array 0 .. 200 of int
    for x : -100 .. 100
        data(x+100) := round(findY(x)) % Place data
    end for
    
    graphData(data)
    
    
    Draw.Line(gposX(vertexX), 0, gposX(vertexX), 400, brightblue) % Graph axis of symmetry
    Draw.FillOval(gposX(reflectionX), gposY(c), 2, 2, brightpurple) % Graph Y-int reflected on axis of symmetry
    Draw.FillOval(gposX(0), gposY(c), 2, 2, purple) % Graph Y-int point
    % Only graph roots if they are not imaginary.
    if not imaginary then
        Draw.FillOval(gposX(root1), gposY(0), 2, 2, green) % Graph root 1 point
        Draw.FillOval(gposX(root2), gposY(0), 2, 2, green) % Graph root 2 point
    end if
    Draw.FillOval(gposX(vertexX), gposY(vertexY), 2, 2, yellow) % Graph vertex point
end updateGraph

% Updates the Information pane
procedure updateInformation
    GUI.SetLabel(iLabel12, "STANDARD FORM: 0 = " + realstr(a, 0) + "x\^2 " + translateToFunction(b) + "x " + translateToFunction(c)) % Show standard form
    GUI.SetLabel(iLabel11, "FACTORED FORM: f(x) = " + realstr(a, 0) + "(x " + translateToFunction(-root1) + ")(x " + translateToFunction(-root2) + ")")
    GUI.SetLabel(iLabel10, "VERTEX FORM: y = " + realstr(a, 0) + "(x " + translateToFunction(-vertexX) + ")\^2 " + translateToFunction(vertexY)) % Show vertex form
    
    % Check the opening direction
    if a > 0 then
        GUI.SetLabel(iLabel9, "OPENING DIRECTION: Upwards") % Set Opening Direction Info
    else
        GUI.SetLabel(iLabel9, "OPENING DIRECTION: Downwards") % Set Opening Direction Info
    end if
    
    GUI.SetLabel(iLabel8, "HORIZONTAL TRANSLATION: " + realstr(vertexX, 0)) % Set Horizontal Translation Info
    GUI.SetLabel(iLabel7, "VERTICAL TRANSLATION: " + realstr(vertexY, 0)) % Set Vertical Translation Info
    GUI.SetLabel(iLabel6, "VERTEX: (" + realstr(vertexX, 0) + ", " + realstr(vertexY, 0) + ")") % Set Vertex Info
    
    % Check if roots are imaginary
    if not imaginary then
        GUI.SetLabel(iLabel5, "ROOTS: " + realstr(root1, 0) + ", " + realstr(root2, 0)) % Set Root Info (Not imaginary)
    else
        GUI.SetLabel(iLabel5, "ROOTS: " + realstr(root1, 0) + "i, " + realstr(root2, 0) + "i") % Set Root Info (Imaginary)
    end if
    
    GUI.SetLabel(iLabel4, "Y-INTERCEPT: " + realstr(c, 0)) % Set Y-Intercept Info
    GUI.SetLabel(iLabel3, "Y-INT REFLECTION (X): " + realstr(vertexX * 2, 0)) % Set Y-Intercept Reflection Info
    GUI.SetLabel(iLabel2, "STRETCH FACTOR: " + realstr(a, 0)) % Set Stretch Factor Info
    GUI.SetLabel(iLabel1, "DISCRIMINANT: " + realstr(discriminant, 0)) % Set Fiscriminant Info
end updateInformation

% Update everything
procedure update
    updateError
    updateValues
    updateInformation
    updateGraph
end update

%Updates the A value
procedure aValueEntered(text : string)
    aValid := strrealok(text) and text not= "0" % Check if the value entered is valid and not 0
    if aValid then a := strreal(text) else a := 1 end if % Update a
    update
end aValueEntered

%Updates the B value
procedure bValueEntered(text : string)
    bValid := strrealok(text) % Check if the value entered is valid
    if bValid then b := strreal(text) else b := 0 end if % Update b
    update
end bValueEntered

%Updates the C value
procedure cValueEntered(text : string)
    cValid := strrealok(text) % Check if the value entered is valid
    if cValid then c := strreal(text) else c := 0 end if % Update c
    update
end cValueEntered

procedure save
    % Save image of graph
    var graph := Pic.New(400, 0, 799, 399)
    Pic.Save(graph, "Saved-Graph.bmp")
    
    var stream : int % File Stream Variable
    open : stream, "Saved-Graph.txt", put % Open File Stream
    
    put : stream, "--------------"
    
    put : stream, "A Variable: " + realstr(a, 0) % Save a variable
    put : stream, "B Variable: " + realstr(b, 0) % Save b variable
    put : stream, "C Variable: " + realstr(c, 0) % Save c variable
    
    put : stream, "--------------"
    
    put : stream, "Standard Form: 0 = " + realstr(a, 0) + "x\^2 " + translateToFunction(b) + "x " + translateToFunction(c) % Save equation in standard form
    put : stream, "Factored Form: f(x) = " + realstr(a, 0) + "(x " + translateToFunction(-root1) + ")(x " + translateToFunction(-root2) + ")" % Save equation in factored form
    put : stream, "Vertex Form: y = " + realstr(a, 0) + "(x - " + realstr(vertexX, 0) + ")\^2 + " + realstr(vertexY, 0) % Save equation in vertex form
    
    put : stream, "--------------"
    
    if a > 0 then % Save opening direction
        put : stream, "Opening Direction: Upwards"
    else
        put : stream, "Opening Direction: Downwards"
    end if
    
    put : stream, "Horizontal Translation: " + realstr(vertexX, 0) % Save horizontal translation
    put : stream, "Vertical Translation: " + realstr(vertexY, 0) % Save vertical translation
    put : stream, "Vertex: (" + realstr(vertexX, 0) + ", " + realstr(vertexY, 0) + ")" % Save vertex
    
    if not imaginary then % Save roots
        put : stream, "Roots: " + realstr(root1, 0) + ", " + realstr(root2, 0)
    else
        put : stream, "Roots: " + realstr(root1, 0) + "i, " + realstr(root2, 0) + "i"
    end if
    
    put : stream, "Y-Intercept: " + realstr(c, 0) % Save y-intercept
    put : stream, "Y-Intercept Reflection (X): " + realstr(vertexX * 2, 0) % Save y-intercept reflection
    put : stream, "Stretch Factor: " + realstr(a, 0) % Save stretch factor
    put : stream, "Discriminant: " + realstr(discriminant, 0) % Save discriminant
    
    put : stream, "--------------"
    
    close : stream % Close output stream
end save

% Window Creation
setscreen("graphics:800;400,nobuttonbar") % Open The Window
GUI.SetBackgroundColor(gray) % Sets the background color
const centerLine := GUI.CreateLine(396, 0, 396, 400, GUI.EXDENT) % Create the CenterLine

const aLabel := GUI.CreateLabel(8  , 375, "A VARIABLE") % Initialize A Label
const bLabel := GUI.CreateLabel(138, 375, "B VARIABLE") % Initialize B Label
const cLabel := GUI.CreateLabel(268, 375, "C VARIABLE") % Initialize C Label
const aField := GUI.CreateTextField(8  , 350, 120, "1", aValueEntered) % Initialize A Field
const bField := GUI.CreateTextField(138, 350, 120, "0", bValueEntered) % Initialize B Field
const cField := GUI.CreateTextField(268, 350, 120, "0", cValueEntered) % Initialize C Field
const sButton := GUI.CreateButton(339, 2, 0, "Save", save)

iLabel12 := GUI.CreateLabel(10, 10 + 22 * 14, "") % Initialize Info Label 12
iLabel11 := GUI.CreateLabel(10, 10 + 22 * 13, "") % Initialize Info Label 11
iLabel10 := GUI.CreateLabel(10, 10 + 22 * 12, "") % Initialize Info Label 10
iLabel9  := GUI.CreateLabel(10, 10 + 22 * 10, "") % Initialize Info Label 9
iLabel8  := GUI.CreateLabel(10, 10 + 22 * 9 , "") % Initialize Info Label 8
iLabel7  := GUI.CreateLabel(10, 10 + 22 * 8 , "") % Initialize Info Label 7
iLabel6  := GUI.CreateLabel(10, 10 + 22 * 7 , "") % Initialize Info Label 6
iLabel5  := GUI.CreateLabel(10, 10 + 22 * 6 , "") % Initialize Info Label 5
iLabel4  := GUI.CreateLabel(10, 10 + 22 * 5 , "") % Initialize Info Label 4
iLabel3  := GUI.CreateLabel(10, 10 + 22 * 4 , "") % Initialize Info Label 3
iLabel2  := GUI.CreateLabel(10, 10 + 22 * 3 , "") % Initialize Info Label 2
iLabel1  := GUI.CreateLabel(10, 10 + 22 * 2 , "") % Initialize Info Label 1
eLabel   := GUI.CreateLabel(10, 10 , "") % Initialize Error Label

% Calculate initial state
update

loop % Keep program alive and update gui
    exit when GUI.ProcessEvent
end loop