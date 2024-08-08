.pragma library

// let curVal = 0
let previousOperator = ""
let openBracket = false
let lastOp = ""
let digits = ""
let expression = ""
let password = ""

function checkPassword() {
    if (password === "" && lastOp === "1")
        password = "1"
    if (password === "1" && lastOp === "2")
        password = "12"
    if (password === "12" && lastOp === "3")
    {
        password = ""
        return true
    }
    return false
}

function isOperationDisabled(op, display) {
    if (digits === "" && !((op >= "0" && op <= "9") || op === "C"))
        return true
    if (op === '=' && previousOperator.length != 1)
        return true
    if (op === "." && digits.search(/\./) != -1)
        return true
    if (op === "C" && display.isDisplayEmpty())
        return true

    return false
}

function digitPressed(op, display) {
    if (previousOperator === ")")
        return
    if (op === "." && (previousOperator === "." || !(lastOp >= "0" && lastOp <= "9")))
        return
    if (op === ".")
        previousOperator = "."
    if (lastOp.toString().length === 1 && ((lastOp >= "0" && lastOp <= "9") || lastOp === ".") ) {
        if (digits.length >= display.maxDigits)
            return
        digits = digits + op.toString()
        expression = expression + op.toString()
        display.allClear()
        display.appendDigit(expression.toString())
        // display.appendDigit(op.toString())

    } else {
        digits = op.toString()
        expression = expression + digits
        display.allClear()
        display.appendDigit(expression)
    }
    lastOp = op
}

function operatorPressed(op, display) {

    if (op === "()") {
        if (openBracket === true){
            if (!(lastOp >= "0" && lastOp <= "9"))
                return
            previousOperator = ")"
            lastOp = ")"
            expression = expression + ")"
        }
        else {
            if ((lastOp >= "0" && lastOp <= "9") || lastOp === ")" || lastOp === ".")
                return
            previousOperator = "("
            lastOp = "("
            expression = expression + "("
        }
        openBracket = !openBracket
        display.allClear()
        display.appendDigit(expression)
        return
    }

    // if (isOperationDisabled(op, display))
    //     return

    if (op === "±") {
        // digits = Number(digits.valueOf() * -1).toString()
        // display.setDigit(display.displayNumber(Number(digits)))
        if (expression[0] === '-')
            expression = expression.substring(1)
        else
            expression = '-' + expression
        display.allClear()
        display.appendDigit(expression)
        return
    }

    if (op === "+" || op === "−" || op === "×" || op === "÷" || op === "%") {
        if(!(lastOp >= "0" && lastOp <= "9" || lastOp === "." || lastOp === ")"))
            return
        previousOperator = op
        lastOp = op
        expression = expression + op
        display.allClear()
        display.appendDigit(expression)
        return
    }

    if (op === "=") {
        if (!(lastOp >= "0" && lastOp <= "9" || lastOp === ")") || openBracket === true)
            return
        previousOperator = ""
        display.allClear()
        let expr = expression
        expr = expr.replace(/×/g, "*")
        expr = expr.replace(/÷/g, "/")
        expr = expr.replace(/−/g, "-")
        display.newLine("", expression, eval(expr))
    }

    if (op === "C") {
        previousOperator = ""
        display.allClear()
        lastOp = ""
        digits = ""
        previousOperator = ""
        expression = ""
    }
}
