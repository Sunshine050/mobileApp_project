const Booking = require('../models/booking.model');
const Room = require('../models/room.model');
const User = require('../models/user.model');
//-------------------------------------------------------------------//
const userData = async (req, res) => {
    const { userId } = req.user;

    try {
        const userData = await User.profileData(userId);
        return res.json(userData);
    } catch (error) {
        res.status(500).send('Internal server error');
    }
}
//-------------------------------------------------------------------//
const history = async (req, res) => {
    const { userId, role } = req.user;

    try {
        Booking.getAllBooking(userId, role, (err, result) => {
            if (err) return res.status(500).send('Internal server error');
            res.json(result);
        });
    } catch (error) {
        res.status(500).send('Internal server error');
    }
}
//-------------------------------------------------------------------//
const search = async (req, res) => {
    const { roomName } = req.params;
    const { userId, role } = req.user;

    try {
        Booking.findByRoomName(roomName, userId, role, (err, result) => {
            if (err) return res.status(500).send('Internal server error');
            res.json(result);
        });
    } catch (error) {
        res.status(500).send('Internal server error');
    }
}

//-------------------------------------------------------------------//
// data for dashboard
const summary = async (req, res) => {
    const { role } = req.user;

    try {
        if (role !== "student") {
            Room.getSlotSummary((err, result) => {
                if (err) { res.status(500).send("Internal Server Error") }
                return res.json(result);
            });
        } else {
            return res.status(403).send('Forbidden to access the data');
        }
    } catch (err) {
        console.error(err);
        res.status(500).send("Internal Server Error");
    }
};
//-------------------------------------------------------------------//
module.exports = {
    userData,
    history,
    search,
    summary // data for dashboard
}
//-------------------------------------------------------------------//