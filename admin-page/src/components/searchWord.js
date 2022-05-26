import React, {useEffect, useState} from 'react'
import Table from './Table'
import axios from "axios";
import {Loading} from "./loading";
import {toast} from "react-toastify";

const getData = async (path) => {
    const response = await axios({
        method: 'GET',
        url: `http://ec2-54-180-2-66.ap-northeast-2.compute.amazonaws.com:5000/${path}`,
    });
    return response.data;
}
const onAddClick = async () => {
    const word = document.getElementById("search").value;

    await axios({
        method: 'POST',
        url: 'http://ec2-54-180-2-66.ap-northeast-2.compute.amazonaws.com:5000/words',
        data : {
            'word': word,
        },
    })
    .then(()=>toast.success("성공적으로 처리되었습니다!"))
    .catch(()=>toast.error("다시 시도해주세요."))
}

function SearchWord() {
    const [data, setData] = useState([]);
    const [requestData, setRequestData] = useState([]);

    useEffect(()=>{
        async function fetchRequest(){
            setRequestData(await getData('requests'))
        }
        async function fetchData(){
            setData(await getData('words'))
        }

        fetchRequest();
        fetchData();
    },[])

    const RequestColumns = React.useMemo(() => [
        {
            Header: "title",
            accessor: 'title',
        },
    ], [])
    const wordColumns = React.useMemo(() => [
        {
            Header: "title",
            accessor: 'word',
        },
    ], [])

    if (!requestData){
        return <Loading/>
    }
    else {
        return <>
            <header className="bg-white shadow">
                <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
                    <h1 className="text-3xl font-bold text-gray-900">검색어</h1>
                </div>
            </header>

            <div className="min-h-screen bg-gray-100 text-gray-900 pt-10 pb-40">
                <div className="mt-1 flex flex-row rounded-md justify-center mb-10">
                    <input
                        type="text"
                        name="search"
                        id="search"
                        className="basis-2/5 p-4 shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border border-gray-300 rounded-md resize-none h-16"
                        placeholder="추가할 검색어를 입력해주세요"
                    />
                    <div
                        onClick={()=>onAddClick()}
                        className="w-32 h-16 cursor-pointer inline-flex justify-center py-4 px-4 border border-transparent shadow-sm text-xl font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                    >
                        추가
                    </div>
                </div>

                <div className="flex flex-row max-w-7xl mx-auto ">
                    <main className="basis-2/5 max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 pt-4">
                        <div className="mt-4">
                            <h1 className="text-3xl font-bold text-gray-900 mb-10">사용자 요청 검색어</h1>
                            <Table columns={RequestColumns} data={requestData}/>
                        </div>
                    </main>
                    <main className="basis-2/5 max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 pt-4">
                        <div className="mt-4">
                            <h1 className="text-3xl font-bold text-gray-900 mb-10">현재 검색어</h1>
                            <Table columns={wordColumns} data={data}/>
                        </div>
                    </main>
                </div>
            </div>
        </>
    }
}

export default SearchWord;